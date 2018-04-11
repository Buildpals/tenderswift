# frozen_string_literal: true

class ContractorsController < ApplicationController
  before_action :authenticate_contractor!, only: [:dashboard]

  def dashboard; end

  def sign_up_and_purchase
    if Rails.env.development? || Rails.env.test?
      create_user_and_purchase_tender
    else
      sign_up_and_purchase_tender_with_payment
    end
  end

  private

  def create_user_and_purchase_tender
    @request_for_tender = RequestForTender.find(params[:id])

    @contractor = Contractor.new(contractor_params)
    @contractor.tenders.build(
      request_for_tender: @request_for_tender,
      customer_number: purchase_params[:customer_number],
      network_code: purchase_params[:network_code],
      vodafone_voucher_code: purchase_params[:vodafone_voucher_code],
      transaction_id: 'DEVELOPMENT_TRANSACTION',
      amount: @request_for_tender.selling_price,
      status: 'success',
      purchased: true,
      purchase_time: Time.current
    )

    if @contractor.save
      sign_in_and_redirect @contractor, notice: 'You have purchased this tender successfully'
    else
      render :'contractors/portal', layout: 'portal'
    end
  end

  def sign_up_and_purchase_tender_with_payment
    @tender = Tender.new(email: params[:tender][:email],
                         company_name: params[:tender][:company_name],
                         phone_number: params[:tender][:phone_number])
    @tender.request_for_tender_id = params[:tender][:request_for_tender_id]
    @tender.purchase_time = Time.current
    @tender.save!
    payload = extract_payload(params[:tender][:tender_transaction_attributes],
                              params[:tender][:request_for_tender_id])
    json_document = get_json_document(payload)
    puts payload
    authorization_string = hmac_auth(json_document)
    # params[:participant][:tender_transaction_attributes][:participant_id] = @participant.id
    # puts params[:participant][:tender_transaction_attributes]
    results = TenderTransaction.make_payment(authorization_string,
                                             payload,
                                             params[:tender][:tender_transaction_attributes][:customer_number],
                                             params[:tender][:tender_transaction_attributes][:amount],
                                             params[:tender][:tender_transaction_attributes][:vodafone_voucher_code],
                                             params[:tender][:tender_transaction_attributes][:network_code],
                                             params[:tender][:tender_transaction_attributes][:status],
                                             @tender,
                                             payload['transaction_id'])
    if working_url?(results)
      flash[:notice] = "Visit #{view_context.link_to('here in', results)}
                        another tab to finish the paying with VISA/MASTER CARD.
                        After paying come back and refresh this page."
    else
      flash[:notice] = results + '. Check your email after responding to the
                                 prompt on your phone. Thank you!'
    end
    redirect_to participants_required_documents_url @tender
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contractor_params
    params.require(:contractor)
          .permit(:company_name,
                  :phone_number,
                  :email,
                  :password,
                  tenders_attributes: %i[id
                                         network_code
                                         customer_number
                                         vodafone_voucher_code
                                         _destroy])
  end

  def purchase_params
    params.permit(:network_code,
                  :customer_number,
                  :vodafone_voucher_code)
  end
end
