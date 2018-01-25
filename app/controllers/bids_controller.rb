class BidsController < ApplicationController
  before_action :set_participant
  before_action :authenticate_quantity_surveyor!


  def messages
  end

  def boq
    @request = @participant.request_for_tender
    #gon.jbuilder
  end

  def questionnaire
  end

  def contractor_information
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_participant
    @participant = Participant.find_by(auth_token: params[:id])
  end
end
