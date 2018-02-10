class TenderTransactionsController < ApplicationController
  before_action :set_tender_transaction, only: [:show, :edit, :update, :destroy]

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
    payload = Hash.new
    tender_transaction_params.each { |k, v|
      unless k.eql?('participant_id') || k.eql?('request_for_tender_id')
        payload[k] = v
      end
    }
    current_time = Time.new
    current_time = current_time.to_i
    payload['transaction_id'] = current_time
    payload['callback_url'] = TenderTransaction.call_back_url
    payload['client_id'] = TenderTransaction.client_id
    payload['description'] = TenderTransaction.description
    payload['amount'] = RequestForTender.find(params[:tender_transaction][:request_for_tender_id]).selling_price
    payload = payload.sort_by{ |x, y| x}.to_h
    json_document = JSON.generate(payload)
    ruby_hash_representation = JSON.parse(json_document)
    message = TenderTransaction.create_message(ruby_hash_representation)
    authorization = TenderTransaction.auth_signature(message)
    results_url = TenderTransaction.make_payment(authorization, payload, tender_transaction_params, current_time)

    unless results_url.eql?(':null')
      redirect_to results_url
    end

  end

  # PATCH/PUT /tender_transactions/1
  # PATCH/PUT /tender_transactions/1.json
  def update
    respond_to do |format|
      if @tender_transaction.update(tender_transaction_params)
        format.html { redirect_to @tender_transaction, notice: 'Tender transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @tender_transaction }
      else
        format.html { render :edit }
        format.json { render json: @tender_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tender_transactions/1
  # DELETE /tender_transactions/1.json
  def destroy
    @tender_transaction.destroy
    respond_to do |format|
      format.html { redirect_to tender_transactions_url, notice: 'Tender transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete_transaction
    transaction_id = params['transaction_id']
    status = params['status']
    message = params['message']
    transaction = TenderTransaction.find_by(transaction_id: transaction_id)
    transaction.attributes.each do |attr|
      puts attr
    end
    if status.eql?('SUCCESS')
      transaction.status = 'success'
      transaction.save!
      participant = Participant.find(transaction.participant_id)
      participant.update(status: 'participating')
      redirect_to participants_questionnaire_url(participant), notice: message
    else
      transaction.status = 'failed'
      transaction.save!
      redirect_to participants_project_information_url(participant), notice: message
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tender_transaction
      @tender_transaction = TenderTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tender_transaction_params
      params.require(:tender_transaction).permit(:customer_number, :amount, :transaction_id, :voucher_code, :network_code, :status, :participant_id, :request_for_tender_id)
    end
end
