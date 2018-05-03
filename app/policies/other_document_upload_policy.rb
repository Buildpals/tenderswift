# frozen_string_literal: true

class OtherDocumentUploadPolicy
  attr_reader :quantity_surveyor, :other_document_upload

  def initialize(quantity_surveyor, other_document_upload)
    @quantity_surveyor = quantity_surveyor
    @other_document_upload = other_document_upload
  end

  def pdf_viewer?
    owns_the_request_for_tender_for_the_other_document?
  end

  def image_viewer?
    owns_the_request_for_tender_for_the_other_document?
  end

  def update?
    owns_the_request_for_tender_for_the_other_document?
  end

  private

  def owns_the_request_for_tender_for_the_other_document?
    true if @quantity_surveyor.id == @other_document_upload.tender
                                      .request_for_tender
                                      .quantity_surveyor.id
  end
end
