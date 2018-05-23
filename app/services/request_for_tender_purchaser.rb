# frozen_string_literal: true

require 'securerandom'

class RequestForTenderPurchaser
  NETWORK_CODES = %w[AIR MTN TIG VOD].freeze

  attr_reader :contractor
  attr_reader :request_for_tender
  attr_reader :tender
  attr_reader :error_message

  def initialize(request_for_tender:, contractor:, korba_web_api:)
    @logger = Logger.new(STDOUT)
    @request_for_tender = request_for_tender
    @contractor = contractor
    @korba_web_api = korba_web_api
    @error_message = nil
  end

  def self.build(request_for_tender:, contractor:)
    new(contractor: contractor,
        request_for_tender: request_for_tender,
        korba_web_api: KorbaWeb.new)
  end

  def purchase(payment_params)
    @customer_number = payment_params[:customer_number]
    @network_code = payment_params[:network_code]
    @vodafone_voucher_code = payment_params[:vodafone_voucher_code]

    validate_is_published! @request_for_tender
    @tender = find_or_create_tender
    validate_is_not_purchased! @tender
    transaction_id = SecureRandom.uuid
    store_transaction_attempt(transaction_id)
    make_transaction_request(transaction_id)
    store_transaction_success
    @logger.info('Successful transaction request made to korbaweb')
    true
  rescue TenderNotPublishedError
    @logger.warn(TenderNotPublishedError)
    @error_message = 'The request for tender does not exist'
    false
  rescue TenderPurchasedAlreadyError
    @logger.warn(TenderPurchasedAlreadyError)
    @error_message = 'You have purchased this tender already'
    false
  rescue KorbaWeb::MissingCustomerNumberError
    @logger.warn(KorbaWeb::MissingCustomerNumberError)
    @error_message = 'Please enter a phone number'
    false
  rescue KorbaWeb::InvalidNetworkCodeError
    @logger.warn(KorbaWeb::InvalidNetworkCodeError)
    @error_message = 'Please select a network'
    false
  rescue KorbaWeb::MissingVoucherCodeError
    @logger.warn(KorbaWeb::MissingVoucherCodeError)
    @error_message = 'You have selected Vodafone, please enter a voucher code'
    false
  rescue KorbaWeb::InvalidCustomerNumberError
    @logger.warn(KorbaWeb::InvalidCustomerNumberError)
    @error_message = 'Please enter a valid phone number'
    false
  rescue KorbaWeb::KorbaWebError
    @logger.error(KorbaWeb::KorbaWebError)
    @error_message = 'Sorry, something bad happened'
    false
  end

  def payment_success?
    @tender = Tender.find_by(request_for_tender: @request_for_tender,
                             contractor: @contractor)
    if Rails.env.development? || Rails.env.test? &&
                                 purchase_timed_out?(@tender)
      save_transaction_success('Automatically purchased in development mode')
    end

    @tender.purchased?
  end

  def payment_failed?
    @tender = Tender.find_by(request_for_tender: @request_for_tender,
                             contractor: @contractor)

    @error_message = purchase_request_message if @tender.failed?
    @tender.failed?
  end

  def complete_transaction(params)
    @tender = Tender.find_by(transaction_id: params['transaction_id'])

    if @tender.nil?
      @logger.warn("Invalid transaction_id: #{params['transaction_id']}")
      return
    end

    if params['status'].eql?('SUCCESS')
      save_transaction_success(params['message'])
    else
      save_transaction_failure(params['message'])
    end
  end

  private

  def validate_is_published!(request_for_tender)
    raise TenderNotPublishedError unless request_for_tender.published?
  end

  def find_or_create_tender
    Tender.find_or_create_by(request_for_tender: @request_for_tender,
                             contractor: @contractor)
  end

  def validate_is_not_purchased!(tender)
    raise TenderPurchasedAlreadyError if tender.purchased?
  end

  def store_transaction_attempt(transaction_id)
    @tender.update!(customer_number: @customer_number,
                    network_code: @network_code,
                    vodafone_voucher_code: @vodafone_voucher_code,
                    amount: @request_for_tender.selling_price,
                    transaction_id: transaction_id,
                    purchase_request_sent_at: Time.current)
  end

  def make_transaction_request(transaction_id)
    @korba_web_api.call(
      customer_number: @customer_number,
      amount: @request_for_tender.selling_price,
      transaction_id: transaction_id,
      network_code: @network_code,
      vodafone_voucher_code: @vodafone_voucher_code,
      description: to_s
    )
  end

  def store_transaction_success
    @tender.update!(purchase_request_status: :pending,
                    purchase_request_message: :pending)
  end

  def purchase_timed_out?(tender)
    Time.current >= tender.purchase_request_sent_at + 30.seconds
  end

  def save_transaction_success(message)
    @logger.info('KorbaWeb successfully completed the transaction' \
                            ": #{message}")
    @tender.update!(purchased_at: Time.current,
                    purchase_request_status: :success,
                    purchase_request_message: message)
    TenderTransactionMailer.confirm_purchase_email(@tender).deliver_now
  end

  def save_transaction_failure(message)
    @logger.warn('KorbaWeb failed to complete transaction: ' \
                          ":#{message}")
    @tender.update!(purchase_request_status: :failed,
                    purchase_request_message: message)
  end

  def to_s
    "Purchase of #{@request_for_tender.project_name} by" \
    "#{@contractor.company_name} for #{@request_for_tender.selling_price}"
  end

  class TenderNotPublishedError < RuntimeError
  end

  class TenderPurchasedAlreadyError < RuntimeError
  end
end
