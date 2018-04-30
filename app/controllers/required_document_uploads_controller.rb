# frozen_string_literal: true

class RequiredDocumentUploadsController < QuantitySurveyorsController
  layout 'file_viewer'

  before_action :set_tender
  before_action :set_required_document_upload
  before_action :mark_required_document_as_read

  def pdf_viewer
    authorize @required_document_upload
  end

  def image_viewer
    authorize @required_document_upload
  end

  def update
    authorize @required_document_upload
    @required_document_upload.update(required_document_upload_params)
    flash[:notice] = if @required_document_upload.status.eql?('approved')
                       "You have successfully approved the
                         #{@required_document_upload.required_document.title}"
                     else
                       "#{@required_document_upload.required_document.title}
                         was rejected"
                     end
    redirect_to bid_required_documents_url(@required_document_upload.tender)
  end

  private

  def set_tender
    @tender = Tender.find(params[:id])
  end

  def set_required_document_upload
    @required_document_upload =
      RequiredDocumentUpload.find(params[:required_document_upload_id])
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
