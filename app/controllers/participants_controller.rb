class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:edit, :update, :destroy,
                                         :show_interest_in_request_for_tender,
                                         :show_disinterest_in_request_for_tender,
                                         :messages,
                                         :project_information,
                                         :boq,
                                         :questionnaire,
                                         :results,
                                         :show_boq, :disqualify]

  def messages
    @participant.update(status: 'read', request_read_time: Time.current) if @participant.not_read?
  end

  def project_information
  end

  def boq
    @boq = @participant.boq
    gon.jbuilder
  end

  def questionnaire
  end

  def results
  end

  # GET /participants/1/edit
  def edit
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
    respond_to do |format|
      if @participant.update(participant_params)
        format.html {
          if params[:commit] == 'save_rating'
            redirect_to participant_boq_path(@participant), notice: 'Participant was successfully updated.'
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
    respond_to do |format|
      if @participant.update(participant_params)
        format.html {
          if params[:commit] == 'save_rating'
            redirect_to @participant.request_for_tender
          else
            redirect_to @participant.request_for_tender, notice: 'Participant was successfully updated.'
          end
        }
        format.json {render :show, status: :ok, location: @participant}
      else
        format.json {render json: @participant.errors, status: :unprocessable_entity}
      end
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
    puts @participant.status
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def participant_params
    params.require(:participant)
          .permit(:email,
                  :phone_number,
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
                  filled_items_attributes: [:id,
                                            :email,
                                            :phone_number,
                                            :rate,
                                            :_destroy])
  end
end
