# frozen_string_literal: true

class BidsController < QuantitySurveyorsController
  layout 'file_viewer', only: %i[pdf_viewer image_viewer]

  before_action :mark_required_document_as_read, only: %i[image_viewer
                                                          pdf_viewer]

  before_action :set_tender, only: %i[required_documents
                                      boq
                                      other_documents
                                      disqualify
                                      undo_disqualify
                                      rate]

  before_action :authenticate_quantity_surveyor!

  def required_documents; end

  def boq; end

  def other_documents; end

  def pdf_viewer; end

  def image_viewer; end

  def update
    set_required_document_upload
    @required_document_upload.update(bid_params)
    flash[:notice] = if @required_document_upload.status.eql?('approved')
                       "You have successfully approved the
                         #{@required_document_upload.required_document.title}"
                     else
                       "#{@required_document_upload.required_document.title}
                         was rejected"
                     end
    redirect_to bid_required_documents_url(@required_document_upload.tender)
  end

  def disqualify
    if @tender.update(disqualified: true)
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: "#{@tender.company_name} has been disqualified"
    else
      redirect_back fallback_location: root_path,
                    notice: "An error occurred while trying to disqualify #{@tender.company_name}"
    end
  end

  def undo_disqualify
    if @tender.update(disqualified: false)
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: "#{@tender.company_name} has been re-added to the shortlist"
    else
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: "An error occurred while trying to re-add #{@tender.company_name} to shortlist"
    end
  end

  def rate
    if @tender.update(rating: params[:rating])
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: "The rating for #{@tender.company_name} has been updated"
    else
      redirect_back fallback_location: bid_required_documents_path(@tender),
                    notice: "An error occurred while trying to update the rating for #{@tender.company_name}"
    end
  end

  private

  def mark_required_document_as_read
    set_tender
    set_required_document_upload
    @required_document_upload.update!(read: true)
  end

  def set_tender
    @tender = Tender.find(params[:id])
  end

  def set_required_document_upload
    @required_document_upload =
      RequiredDocumentUpload.find(params[:required_document_upload_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bid_params
    params.require(:required_document_upload)
          .permit(:required_document_id,
                  :tender_id,
                  :document,
                  :status)
  end
end
