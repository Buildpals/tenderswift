# frozen_string_literal: true

class RequestForTenderPurchaser
  NETWORK_CODES = %w[AIR MTN TIG VOD].freeze

  attr_reader :contractor
  attr_reader :request_for_tender
  attr_reader :tender

  def initialize(request_for_tender:, contractor:)
    @request_for_tender = request_for_tender
    @contractor = contractor
    @errors = []
  end

  def purchase(payment_params)
    @customer_number = payment_params['customer_number']
    @network_code = payment_params['network_code']
    @vodafone_voucher_code = payment_params['vodafone_voucher_code']

    validate_purchase_params
    purchase_tender if @errors.empty?
    self
  end

  def payment_confirmed?
    @tender = Tender.find_by(request_for_tender: @request_for_tender,
                             contractor: @contractor)

    return false if Time.current < @tender.purchase_request_sent_at + 30.seconds

    if @tender.update(purchased_at: Time.current,
                      purchase_request_status: :success)
      true
    else
      false
    end
  end

  def self.complete_transaction(transaction_id:, status:, message:)
    @tender = Tender.find(transaction_id)
    if status.eql?('SUCCESS') &&
       @tender.update(purchased_at: Time.current,
                      status: :success,
                      message: message)
      TenderTransactionMailer.confirm_purchase_email(@tender).deliver_now
    else
      @tender.update(status: :failed, message: message)
    end
  end

  def success?
    @errors.empty?
  end

  private

  def validate_purchase_params
    @errors << 'Phone number can\'t be blank' if @customer_number.blank?
    @errors << 'Phone number is invalid' if @customer_number.length != 10
    @errors << 'Network code invalid' unless NETWORK_CODES.include? @network_code
    if @network_code == 'VOD'
      @errors << 'Voucher code can\'t be blank' if @vodafone_voucher_code.blank?
      @errors << 'Voucher code is invalid' if @vodafone_voucher_code.length != 6
    end

    @tender = find_or_create_tender
    @errors << 'You have already purchased this tender' if @tender.purchased?
  end

  def purchase_tender
    call_korba_web_api
    store_purchase_request
  end

  def store_purchase_request
    if @tender.update(customer_number: @customer_number,
                      network_code: @network_code,
                      vodafone_voucher_code: @vodafone_voucher_code,
                      purchase_request_status: :pending,
                      # TODO: FIX THIS
                      purchase_request_message: :pending,
                      purchase_request_sent_at: Time.current)
    else
      @errors << @tender.errors.full_messages
    end
  end

  def find_or_create_tender
    Tender.find_or_create_by(request_for_tender: @request_for_tender,
                             contractor: @contractor)
  end

  def call_korba_web_api
    response = KorbaWeb.build(
      customer_number: @customer_number,
      amount: @request_for_tender.selling_price,
      transaction_id: @tender.id,
      network_code: @network_code,
      vodafone_voucher_code: @vodafone_voucher_code,
      description: to_s
    ).call

    process_response(response)
  end

  def process_response(response)
    if response.success?
      response
    else
      Rails.logger.error("#{response.error_code}: #{response.error_message}")
      @errors << 'There was an error purchasing this tender'
    end
  end

  def to_s
    "Purchase of #{@request_for_tender.project_name} by" \
    "#{@contractor.company_name} for #{@request_for_tender.selling_price}"
  end
end
