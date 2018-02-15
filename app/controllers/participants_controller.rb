class ParticipantsController < ApplicationController
  before_action :set_participant, only: %i[update destroy
                                          show_interest_in_request_for_tender
                                          show_disinterest_in_request_for_tender
                                          messages
                                          project_information
                                          boq
                                          questionnaire
                                          results
                                          show_boq
                                          disqualify undo_disqualify rate]

  before_action :set_read_time, only: %i[project_information
                                      boq questionnaire]

  include TenderTransactionsHelper

  include ApplicationHelper

  def messages
  end

  def project_information
    @tender_transaction = TenderTransaction.new
  end

  def boq
    @tender_transaction = TenderTransaction.new
    @boq = @participant.boq
    #gon.jbuilder
  end

  def questionnaire
    @tender_transaction = TenderTransaction.new
  end

  def results
  end

  # POST /participants
  # POST /participants.json
  def create
    @participant = Participant.new(participant_params)

    respond_to do |format|
      if @participant.save
        format.html {redirect_to @participant, notice: 'Participant was successfully created.'}
        format.json {render :show, status: :created, location: @participant}
      else
        format.html {render :new}
        format.json {render json: @participant.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /participants/1
  # PATCH/PUT /participants/1.json
  def update
    rates = @participant.rates.where(boq: @participant.request_for_tender.boq)
    unless rates.nil?
      @participant.total_bid = @participant.calculate_contract_sum
    end
    respond_to do |format|
      if @participant.update(participant_params)
        format.html {
          if params[:commit] == 'save_rating'
            redirect_to bid_boq_path(@participant), notice: 'Participant was successfully updated.'
          else
            redirect_to @participant, notice: 'Participant was successfully updated.'
          end
        }
        format.json {render :show, status: :ok, location: @participant}
      else
        format.html {render :edit}
        format.json {render json: @participant.errors, status: :unprocessable_entity}
      end
    end
  end

  def disqualify
    if @participant.update(disqualified: true)
      redirect_back fallback_location: bid_boq_path(@participant),
                  notice: "#{@participant.company_name} has been disqualified"
    else
      redirect_back fallback_location: root_path,
                  notice: "An error occurred while trying to disqualify #{@participant.company_name}"
    end
  end

  def undo_disqualify
    if @participant.update(disqualified: false)
      redirect_back fallback_location: bid_boq_path(@participant),
                  notice: "#{@participant.company_name} has been re-added to the shortlist"
    else
      redirect_back fallback_location: bid_boq_path(@participant),
                  notice: "An error occurred while trying to re-add #{@participant.company_name} to shortlist"
    end
  end

  def rate
    if @participant.update(rating: params[:rating])
      redirect_back fallback_location: bid_boq_path(@participant),
                    notice: "The rating for #{@participant.company_name} has been updated"
    else
      redirect_back fallback_location: bid_boq_path(@participant),
                    notice: "An error occurred while trying to update the rating for #{@participant.company_name}"
    end
  end

  # GET /show_interest_in_request_for_tender/1
  def show_interest_in_request_for_tender
    @participant.update(status: 'participating', interested_declaration_time: Time.current)
    redirect_to @participant,
                notice: 'The project owner has been notified of your interest in the project. '+
                    'You\'ll find the Bid Requirements and Bill of Quantities when you scroll down this page.'
  end

  # GET /show_disinterest_in_request_for_tender/1
  def show_disinterest_in_request_for_tender
    @participant.update(status: 'not_participating', interested_declaration_time: Time.current)
    redirect_to @participant,
                notice: 'Thank you for your time. You\'ll not receive anymore emails about this project.'
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    @participant.destroy
    respond_to do |format|
      format.html {redirect_to participants_url, notice: 'Participant was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def set_contract_sum
    set_participant
    @participant.contract_sum = params[:contract_sum]
    @participant.save!
  end

  def pay_public_tender
    @participant = Participant.new(email: params[:participant][:email],
                                   company_name: params[:participant][:company_name],
                                   phone_number: params[:participant][:phone_number])
    @participant.request_for_tender_id = params[:participant][:request_for_tender_id]
    @participant.save!
    payload = extract_payload(params[:participant][:tender_transaction_attributes],
                              params[:participant][:request_for_tender_id])
    json_document = get_json_document(payload)
    puts payload
    authorization_string = hmac_auth(json_document)
    params[:participant][:tender_transaction_attributes][:participant_id] = @participant.id
    puts params[:participant][:tender_transaction_attributes]
    results = TenderTransaction.make_payment(authorization_string, payload,
                                                 params[:participant][:tender_transaction_attributes][:customer_number],
                                                 params[:participant][:tender_transaction_attributes][:amount],
                                                 params[:participant][:tender_transaction_attributes][:vodafone_voucher_code],
                                                 params[:participant][:tender_transaction_attributes][:network_code],
                                                 params[:participant][:tender_transaction_attributes][:status],
                                                 @participant.id,
                                                 @participant.request_for_tender.id,
                                                 payload['transaction_id'])
    if results == true
      tender_transaction = TenderTransaction.find_by(transaction_id:
                                                         payload['transaction_id'])
      flash[:notice] = 'Please check your phone for a prompt to complete the transaction.
                        After responding to the prompt, refresh this page'
      redirect_to participants_questionnaire_url tender_transaction.participant
    elsif !results.nil? && working_url?(results)
      redirect_to results
    elsif results.nil?
      redirect_to participants_questionnaire_url @participant
    else
      flash[:notice] = results
      redirect_to participants_questionnaire_url @participant
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_participant
    if params[:id].first(6) == 'guest-'
      request_for_tender = RequestForTender.find(params[:id][6..-1])
      @participant = GuestParticipant.new(request_for_tender)
    else
      @participant = Participant.find_by(auth_token: params[:id])
    end
  end

  def set_read_time
    @participant.update(status: 'read', request_read_time: Time.current) if @participant.not_read?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def participant_params
    params.require(:participant)
          .permit(:email,
                  :phone_number,
                  :participant,
                  :company_name,
                  :first_name,
                  :last_name,
                  :status,
                  :rating,
                  :bid_submission_time,
                  :request_read_time,
                  :interested,
                  :interested_declaration_time,
                  :declination_reason,
                  :removed,
                  :comment,
                  :contract_sum,
                  :request_for_tender_id,
                  tender_transaction_attributes: %i[id
                                                    customer_number
                                                    amount
                                                    transaction_id
                                                    vodafone_voucher_code
                                                    network_code
                                                    status
                                                    request_for_tender_id],
                  filled_items_attributes: %i[id
                                              email
                                              phone_number
                                              rate
                                              _destroy])
  end
end
