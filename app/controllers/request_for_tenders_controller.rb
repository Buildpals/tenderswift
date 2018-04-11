class RequestForTendersController < ApplicationController
  before_action :set_request_for_tender, only: %i[show
                                                  compare_boq
                                                  update
                                                  destroy
                                                  portal
                                                  purchase_tender]

  before_action :authenticate_quantity_surveyor!, except: %i[portal]

  # GET /requests
  # GET /requests.json
  def index
    redirect_to new_quantity_surveyor_registration_path unless quantity_surveyor_signed_in?
    @request_for_tenders = policy_scope(RequestForTender).order(updated_at: :desc)
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /projects/public/1
  def portal
    @tender = Tender.new
    @tender.build_tender_transaction
    @contractor = Contractor.new
    @request_for_tender = RequestForTender.find(params[:id])
    increment_visit_count
    render layout: 'portal'
  end

  def purchase_tender
    if Rails.env.development? || Rails.env.test?
      purchase_tender_without_payment
    else
      purchase_tender_with_payment
    end
  end

  def purchase_tender_without_payment
    @contractor = Contractor.new(email: params[:tender][:email],
                                 company_name: params[:tender][:company_name],
                                 phone_number: params[:tender][:phone_number],
                                 password: params[:tender][:password])

    @tender = @contractor.tenders.build(request_for_tender_id: params[:tender][:request_for_tender_id],
                                        customer_number: params[:tender][:tender_transaction_attributes][:customer_number],
                                        amount: params[:tender][:tender_transaction_attributes][:amount],
                                        transaction_id: params[:tender][:tender_transaction_attributes][:customer_number],
                                        network_code: params[:tender][:tender_transaction_attributes][:network_code],
                                        status: 'success',
                                        amount: '',
                                        vodafone_voucher_code: params[:tender][:tender_transaction_attributes][:vodafone_voucher_code],
                                        purchased: true,
                                        purchase_time: Time.current)

    if @contractor.save
      sign_in_and_redirect @contractor, notice: 'You have purchased this tender successfully'
    else
      render :'request_for_tenders/portal', layout: 'portal'
    end
  end

  def purchase_tender_with_payment
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

  # GET /requests/new
  def new
    @request_for_tender = current_quantity_surveyor.request_for_tenders.new
    authorize @request_for_tender
    @request_for_tender.setup_with_data
    redirect_to edit_tender_information_path @request_for_tender
  end

  def compare_boq
    if @request_for_tender.deadline_over?
      render layout: 'compare_boq'
    else
      redirect_to request_for_tenders_path, notice: 'In accordance with tender
                                                  fairness, you cannot access
                                                  the bids until the deadline
                                                  is past.'
    end
  end

  # POST /requests
  # POST /requests.json
  def create
    @request_for_tender = RequestForTender.new(request_params)
    respond_to do |format|
      if @request_for_tender.save
        format.html { redirect_to @request_for_tender, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request_for_tender }
      else
        format.html { render :new }
        format.json { render json: @request_for_tender.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request_for_tender.update(request_params)
        format.json { render :show, status: :ok, location: @request_for_tender }
        format.js
      else
        format.html { render :edit }
        format.js
        format.json { render json: @request_for_tender.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request_for_tender.destroy
    respond_to do |format|
      format.html { redirect_to request_for_tenders_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def increment_visit_count
    cookie_name = "request-for-tender-#{@request_for_tender.id}"
    return if cookies[cookie_name]

    @request_for_tender.portal_visits += 1
    @request_for_tender.save!
    cookies.permanent[cookie_name] = 'visited'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_request_for_tender
    @request_for_tender = RequestForTender.find(params[:id])
    authorize @request_for_tender
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:request_for_tender)
          .permit(:deadline,
                  :selling_price,
                  :withdrawal_frequency,
                  :bank_name,
                  :branch_name,
                  :account_name,
                  :account_number,
                  :private,
                  tenders_attributes: %i[id
                                              email
                                              phone_number
                                              company_name
                                              _destroy])
  end
end
