class BidsController < ApplicationController

  layout "file_viewer", only: [:pdf_viewer]
  def show
    @participant = Participant.find_by_auth_token(params[:id])
  end

  def questionnaire
    @participant = Participant.find_by_auth_token(params[:id])
  end

  def pdf_viewer
    @participant = Participant.find_by_auth_token(params[:participant_id])
    @required_document_upload = RequiredDocumentUpload.find(
      params[:id]
    )
  end

  def image_viewer
    @participant = Participant.find_by_auth_token(params[:id])
    @required_document_upload = RequiredDocumentUpload.find(
      params[:id]
    )
  end

  def update
    @required_document_upload = RequiredDocumentUpload.find(params[:id])
    @required_document_upload.update(bid_params)
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
