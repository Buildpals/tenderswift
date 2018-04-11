class TenderTransactionsController < ApplicationController
  include TenderTransactionsHelper

  before_action :set_tender_transaction, only: [:update, :destroy]

  include ApplicationHelper


  # GET /tender_transactions/new
  def new
    @tender_transaction = TenderTransaction.new
  end

  # POST /tender_transactions
  # POST /tender_transactions.json
  def create
    @tender = Tender.find(params[:tender_transaction][:tender_id])
    payload = extract_payload(tender_transaction_params,
                              params[:tender_transaction][:request_for_tender_id])
    json_document = get_json_document(payload)
    authorization_string = hmac_auth(json_document)
    results = TenderTransaction.make_payment(authorization_string, payload,
                                                 params[:tender_transaction][:customer_number],
                                                 params[:tender_transaction][:amount],
                                                 params[:tender_transaction][:vodafone_voucher_code],
                                                 params[:tender_transaction][:network_code],
                                                 params[:tender_transaction][:status],
                                                 @tender,
                                                 payload['transaction_id'])
    @tender.purchase_time = Time.new
    @tender.rating = 0
    @tender.save!
    if !results.nil? && working_url?(results)
      link = "<a href=\"#{url_for(results)}\">here in</a>"
      flash[:notice] = "Visit #{link}
                        another tab to finish the paying with VISA/MASTER CARD.
                        After paying come back and refresh this page."
    else
      flash[:notice] = results + '. Check your email after responding to the
                                   prompt on your phone. Thank you!'
    end
    redirect_to tenders_required_documents_url @tender
  end

  # PATCH/PUT /tender_transactions/1
  # PATCH/PUT /tender_transactions/1.json
  def update
    respond_to do |format|
      if @tender_transaction.update(tender_transaction_params)
        format.html do
          redirect_to @tender_transaction,
                      notice: 'Tender transaction was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @tender_transaction }
      else
        format.html { render :edit }
        format.json do
          render json: @tender_transaction.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def complete_transaction
    transaction_id = params['transaction_id']
    status = params['status']
    transaction = TenderTransaction.find_by(transaction_id: transaction_id)
    tender = Tender.find(transaction.tender_id)
    if status.eql?('SUCCESS')
      transaction.status = 'success'
      transaction.save!
      tender.update(purchased: true, purchase_time: Time.current)
      TenderTransactionMailer.confirm_purchase_email(tender).deliver_now
    else
      transaction.status = 'failed'
      transaction.save!
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tender_transaction
    @tender_transaction = TenderTransaction.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tender_transaction_params
    params.require(:tender_transaction)
          .permit(:customer_number,
                  :amount,
                  :transaction_id,
                  :vodafone_voucher_code,
                  :network_code,
                  :status,
                  :tender_id,
                  :request_for_tender_id,
                  tender_attributes: %i[id
                                             email
                                             phone_number
                                             company_name
                                             _destroy])
  end
end
