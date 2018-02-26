class BidsController < ApplicationController
  layout 'file_viewer', only: %i[pdf_viewer image_viewer]

  before_action :mark_required_document_as_read, only: %i[image_viewer
                                                          pdf_viewer]

  before_action :set_participant, only: %i[show questionnaire]

  def show; end

  def questionnaire; end

  def pdf_viewer; end

  def image_viewer; end

  def boq; end

  def update
    @required_document_upload = RequiredDocumentUpload.find(
      params[:required_document_upload_id]
    )
    @required_document_upload.update(bid_params)
    redirect_to bid_questionnaire_url(@required_document_upload.participant)
  end

  private

  def mark_required_document_as_read
    set_participant
    set_required_document_upload
    @required_document_upload.read = true
    @required_document_upload.save!
  end

  def set_participant
    @participant = Participant.find_by_auth_token(params[:id])
  end

  def set_required_document_upload
    @required_document_upload = RequiredDocumentUpload.find(
      params[:required_document_upload_id]
    )
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bid_params
    params.require(:required_document_upload)
          .permit(:required_document_id,
                  :participant_id,
                  :document,
                  :status)
  end
end
