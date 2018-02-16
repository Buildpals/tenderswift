class TenderTransactionsController < ApplicationController
  include TenderTransactionsHelper

  before_action :set_tender_transaction, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /tender_transactions
  # GET /tender_transactions.json
  def index
    @tender_transactions = TenderTransaction.all
  end

  # GET /tender_transactions/1
  # GET /tender_transactions/1.json
  def show
  end

  # GET /tender_transactions/new
  def new
    @tender_transaction = TenderTransaction.new
  end

  # GET /tender_transactions/1/edit
  def edit
  end

  # POST /tender_transactions
  # POST /tender_transactions.json
  def create
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
                                                 params[:tender_transaction][:participant_id],
                                                 params[:tender_transaction][:request_for_tender_id],
                                                 payload['transaction_id'])
    @participant = Participant.find(params[:tender_transaction][:participant_id])
    if !results.nil? && working_url?(results)
      redirect_to results
    else
      flash[:notice] = results + '. Refresh this page after responding to the
                                   prompt on your phone'
      redirect_to participants_questionnaire_url @participant
    end
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

  # DELETE /tender_transactions/1
  # DELETE /tender_transactions/1.json
  def destroy
    @tender_transaction.destroy
    respond_to do |format|
      format.html do
        redirect_to tender_transactions_url,
                    notice: 'Tender transaction was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def complete_transaction
    transaction_id = params['transaction_id']
    status = params['status']
    message = params['message']
    transaction = TenderTransaction.find_by(transaction_id: transaction_id)
    if status.eql?('SUCCESS')
      transaction.status = 'success'
      transaction.save!
      participant = Participant.find(transaction.participant_id)
      participant.update(status: 'participating')
      flash[:notice] = message
      redirect_to participants_questionnaire_url(participant)
    else
      transaction.status = 'failed'
      transaction.save!
      flash[:notice] = message
      redirect_to participants_project_information_url(participant)
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
                  :participant_id,
                  :request_for_tender_id,
                  participant_attributes: %i[id
                                             email
                                             phone_number
                                             company_name
                                             _destroy])
  end
end
