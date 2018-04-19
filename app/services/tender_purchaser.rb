# frozen_string_literal: true

class TenderPurchaser
  def initialize(contractor:,
                 request_for_tender:,
                 phone_number:,
                 network_code:,
                 voucher_code:)
    @contractor = contractor
    @request_for_tender = request_for_tender
    @phone_number = phone_number
    @network_code = network_code
    @voucher_code = voucher_code
  end

  def purchase
    build_purchased_tender
  end

  private

  def build_purchased_tender
    @contractor.tenders.build(
      request_for_tender: @request_for_tender,
      amount: @request_for_tender.selling_price,
      customer_number: @phone_number,
      network_code: @network_code,
      vodafone_voucher_code: @voucher_code,
      transaction_id: 'DEVELOPMENT_TRANSACTION',
      status: 'success',
      purchased: true,
      purchase_time: Time.current
    )
    @contractor.save!
  rescue Exception => exception
    OpenStruct.new(success?: false, contractor: @contractor, error: exception.message)
  else
    OpenStruct.new(success?: true, contractor: @contractor, error: nil)
  end
end
