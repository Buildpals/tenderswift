class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy,
                                         :show_interest_in_request_for_tender,
                                         :show_disinterest_in_request_for_tender]

  # GET /participants
  # GET /participants.json
  def index
    @participants = Participant.all
  end

  # GET /participants/1
  # GET /participants/1.json
  def show
    @participant.update(status: 'read', request_read_time: Time.current) if @participant.not_read?
  end

  # GET /participants/new
  def new
    @participant = Participant.new
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
        format.html {redirect_to @participant, notice: 'Participant was successfully updated.'}
        format.json {render :show, status: :ok, location: @participant}
      else
        format.html {render :edit}
        format.json {render json: @participant.errors, status: :unprocessable_entity}
      end
    end
  end

  # GET /show_interest_in_request_for_tender/1
  def show_interest_in_request_for_tender
    @participant.update(status: 'participating', interested_declaration_time: Time.current)
    puts @participant.status
    redirect_to @participant,
                notice: 'The project owner has been notified of your interest in the project.'
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
    @participant = Participant.find_by(auth_token: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def participant_params
    params.require(:participant).permit(:email, :phone_number)
  end
end
