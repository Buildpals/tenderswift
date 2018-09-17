# frozen_string_literal: true

class OtherDocumentUploadsController < PublishersController
  layout 'file_viewer'

  before_action :set_other_document_upload
  before_action :mark_other_document_upload_as_read

  def show
    authorize @other_document_upload
  end

  def approve
    authorize @other_document_upload
    @other_document_upload.update(status: :approved)
    flash[:notice] = 'You have successfully approved the ' \
                     "#{@other_document_upload.title}"
    redirect_to bid_other_documents_url(@other_document_upload.tender)
  end

  def reject
    authorize @other_document_upload
    @other_document_upload.update(status: :rejected)
    flash[:notice] = "#{@other_document_upload.title} was rejected"
    redirect_to bid_other_documents_url(@other_document_upload.tender)
  end

  private

  def set_other_document_upload
    @other_document_upload = OtherDocumentUpload.find(params[:id])
  end

  def mark_other_document_upload_as_read
    @other_document_upload.update!(read: true)
  end

  def other_document_upload_params
    params.require(:other_document_upload)
          .permit(:title,
                  :tender_id,
                  :document,
                  :status,
                  :read)
  end
end
