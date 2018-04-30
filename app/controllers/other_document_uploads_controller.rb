# frozen_string_literal: true

class OtherDocumentUploadsController < QuantitySurveyorsController
  layout 'file_viewer'

  before_action :set_tender
  before_action :set_other_document_upload
  before_action :mark_other_document_upload_as_read

  def pdf_viewer
    authorize @other_document_upload
  end

  def image_viewer
    authorize @other_document_upload
  end

  def update
    authorize @other_document_upload
    @other_document_upload.update(other_document_upload_params)
    flash[:notice] = if @other_document_upload.status.eql?('approved')
                       "You have successfully approved the
                         #{@other_document_upload.name}"
                     else
                       "#{@other_document_upload.name}
                         was rejected"
                     end
    redirect_to bid_other_documents_url(@other_document_upload.tender)
  end

  private

  def set_tender
    @tender = Tender.find(params[:id])
  end

  def set_other_document_upload
    @other_document_upload =
      OtherDocumentUpload.find(params[:other_document_id])
  end

  def mark_other_document_upload_as_read
    @other_document_upload.update!(read: true)
  end

  def other_document_upload_params
    params.require(:other_document_upload)
          .permit(:name,
                  :tender_id,
                  :document,
                  :status,
                  :read)
  end
end
