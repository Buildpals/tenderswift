# frozen_string_literal: true

class RequestForTenderPurchaser
  NETWORK_CODES = %w[AIR MTN TIG VOD].freeze

  attr_reader :contractor
  attr_reader :request_for_tender
  attr_reader :tender
  attr_reader :error_message

  def initialize(request_for_tender:, contractor:, korba_web_api:)
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
    store_transaction_attempt
    make_transaction_request
    store_transaction_success
    true
  rescue TenderNotPublishedError
    @error_message = 'The request for tender does not exist'
    return false
  rescue TenderPurchasedAlreadyError
    @error_message = 'You have purchased this tender already'
    return false
  rescue KorbaWeb::MissingCustomerNumberError
    @error_message = 'Please enter a phone number'
    return false
  rescue KorbaWeb::InvalidNetworkCodeError
    @error_message = 'Please select a network'
    return false
  rescue KorbaWeb::MissingVoucherCodeError
    @error_message = 'You have selected Vodafone, please enter a voucher code'
    return false
  rescue KorbaWeb::InvalidCustomerNumberError
    @error_message = 'Please enter a valid phone number'
    return false
  rescue KorbaWeb::KorbaWebError
    @error_message = 'Sorry, something bad happened'
    return false
  end

  def payment_confirmed?
    @tender = Tender.find_by(request_for_tender: @request_for_tender,
                             contractor: @contractor)

    if Rails.env.development? && purchase_timed_out?(@tender)
      @tender.update!(purchased_at: Time.current,
                      purchase_request_status: :success,
                      purchase_request_message: 'Automatically purchased in development mode')
    end

    @tender.purchased?
  end

  def self.complete_transaction(transaction_id:, status:, message:)
    @tender = Tender.find(transaction_id)
    if status.eql?('SUCCESS')
      @tender.update!(purchased_at: Time.current,
                      status: :success,
                      purchase_request_message: message)
      TenderTransactionMailer.confirm_purchase_email(@tender).deliver_now
    else
      @tender.update(status: :failed,
                     purchase_request_message: message)
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

  def store_transaction_attempt
    @tender.update!(customer_number: @customer_number,
                    network_code: @network_code,
                    vodafone_voucher_code: @vodafone_voucher_code,
                    amount: @request_for_tender.selling_price,
                    purchase_request_sent_at: Time.current)
  end

  def make_transaction_request
    @korba_web_api.call(
        customer_number: @customer_number,
        amount: @request_for_tender.selling_price,
        transaction_id: @tender.id,
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

  def to_s
    "Purchase of #{@request_for_tender.project_name} by" \
    "#{@contractor.company_name} for #{@request_for_tender.selling_price}"
  end

  class TenderNotPublishedError < RuntimeError
  end

  class TenderPurchasedAlreadyError < RuntimeError
  end
end
