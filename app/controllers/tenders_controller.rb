class TendersController < ApplicationController
  before_action :set_tender, only: %i[update destroy
                                           project_information
                                           boq
                                           required_documents
                                           tender_documents
                                           results
                                           show_boq
                                           required_document_uploads
                                           other_documents
                                           other_document_uploads
                                           rating
                                           save_rates]

  include TenderTransactionsHelper

  include ApplicationHelper

  def project_information
    @tender_transaction = TenderTransaction.new
  end

  def boq
    if @tender.purchased?
      @tender_transaction = TenderTransaction.new
    else
      redirect_to tenders_project_information_path(@tender)
    end
  end

  def required_documents
    if @tender.purchased?
      @tender_transaction = TenderTransaction.new
      @request_for_tender = @tender.request_for_tender
      @required_document_upload = RequiredDocumentUpload.new
      @request_for_tender.required_documents.each do |required_document|
        if @tender.required_document_uploads.find_by(required_document: required_document).nil?
          puts required_document.id
          @tender.required_document_uploads.build(required_document: required_document)
        end
      end
    else
      redirect_to tenders_project_information_url(@tender)
    end
  end

  def tender_documents
    if @tender.purchased?
      @request_for_tender = @tender.request_for_tender
    else
      redirect_to tenders_project_information_url(@tender)
    end
  end

  def other_documents
  end

  def other_document_uploads
    if @tender.update(tender_params)
      flash[:notice] = 'File successfully saved'
    else
      flash[:notice] = 'File should be either a PDF of an Image.
                        And please make sure you provide a name'
    end
    redirect_to tenders_required_documents_url(@tender)
  end

  def results; end

  # POST /tenders
  # POST /tenders.json
  def create
    @tender = Tender.new(tender_params)

    respond_to do |format|
      if @tender.save
        format.html { redirect_to @tender, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @tender }
      else
        format.html { render :new }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tenders/1
  # PATCH/PUT /tenders/1.json
  def update
    respond_to do |format|
      if @tender.update(tender_params)
        format.html { redirect_to @tender, notice: 'Tender was successfully updated.' }
        format.json { render :show, status: :ok, location: @tender }
      else
        format.html { render :edit }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end

  def save_rates
    if @tender.save_rates(params[:rates])
      render json: @tender.to_json(include: :rates), status: :ok,
             location: @tender
    else
      render json: @tender.errors, status: :unprocessable_entity
    end
  end

  def rating
    respond_to do |format|
      if @tender.update(tender_params)
        format.html { redirect_to bid_required_documents_url(@tender), notice: 'Tender was successfully updated.' }
        format.json { render :show, status: :ok, location: @tender }
      else
        format.html { render :edit }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenders/1
  # DELETE /tenders/1.json
  def destroy
    @tender.destroy
    respond_to do |format|
      format.html { redirect_to tenders_url, notice: 'Tender was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pay_public_tender
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
    params[:tender][:tender_transaction_attributes][:tender_id] = @tender.id
    puts params[:tender][:tender_transaction_attributes]
    results = TenderTransaction.make_payment(authorization_string, payload,
                                             params[:tender][:tender_transaction_attributes][:customer_number],
                                             params[:tender][:tender_transaction_attributes][:amount],
                                             params[:tender][:tender_transaction_attributes][:vodafone_voucher_code],
                                             params[:tender][:tender_transaction_attributes][:network_code],
                                             params[:tender][:tender_transaction_attributes][:status],
                                             @tender.id,
                                             @tender.request_for_tender.id,
                                             payload['transaction_id'])
    if !results.nil? && working_url?(results)
      flash[:notice] = "Visit #{view_context.link_to('here in', results)}
                        another tab to finish the paying with VISA/MASTER CARD.
                        After paying come back and refresh this page."
    else
      flash[:notice] = results + '. Check your email after responding to the
                                 prompt on your phone. Thank you!'
    end
    redirect_to tenders_required_documents_url @tender
  end

  def required_document_uploads
    unless @tender.update(tender_params)
      puts @tender.errors.full_messages
      flash[:notice] = 'File should be either a PDF of an Image'
    end
    redirect_to tenders_required_documents_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tender
    if params[:id].first(6) == 'guest-'
      request_for_tender = RequestForTender.find(params[:id][6..-1])
      @tender = GuestParticipant.new(request_for_tender)
      @request_for_tender = request_for_tender
    else
      @tender = Tender.find_by(auth_token: params[:id])
      if @tender.nil?
        redirect_to root_path
      else
        @request_for_tender = @tender.request_for_tender
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tender_params
    params.require(:tender)
          .permit(:request_for_tender_id,
                  :company_name,
                  :phone_number,
                  :email,
                  :rating,
                  :purchased,
                  :submitted,
                  :purchase_time,
                  :submitted_time,
                  :read,
                  :rating,
                  :disqualified,
                  :notes,
                  tender_transaction_attributes: %i[id
                                                    customer_number
                                                    amount
                                                    transaction_id
                                                    vodafone_voucher_code
                                                    network_code
                                                    status
                                                    request_for_tender_id],
                  other_document_uploads_attributes: %i[id
                                                        name
                                                        document
                                                        _destroy],
                  required_document_uploads_attributes: %i[id
                                                           document
                                                           required_document_id
                                                           tender_id
                                                           _destroy])
  end
end
