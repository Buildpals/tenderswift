# frozen_string_literal: true

class RequiredDocumentUploadsController < PublishersController
  layout 'file_viewer'

  before_action :set_required_document_upload
  before_action :mark_required_document_as_read

  def show
    authorize @required_document_upload
  end

  def approve
    authorize @required_document_upload
    @required_document_upload.update(status: :approved)
    flash[:notice] = "You have successfully approved the " \
                     "#{@required_document_upload.required_document.title}"
    redirect_to bid_required_documents_url(@required_document_upload.tender)
  end

  def reject
    authorize @required_document_upload
    @required_document_upload.update(status: :rejected)
    flash[:notice] = "#{@required_document_upload.required_document.title}" \
                     "was rejected"
    redirect_to bid_required_documents_url(@required_document_upload.tender)
  end

  private

  def set_required_document_upload
    @required_document_upload = RequiredDocumentUpload.find(params[:id])
  end

  def mark_required_document_as_read
    @required_document_upload.update!(read: true)
  end

  def required_document_upload_params
    params.require(:required_document_upload)
          .permit(:required_document_id,
                  :tender_id,
                  :document,
                  :status)
  end
end
