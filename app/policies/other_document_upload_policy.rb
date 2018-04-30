# frozen_string_literal: true

class OtherDocumentUploadPolicy
  attr_reader :quantity_surveyor, :other_document_upload

  def initialize(quantity_surveyor, other_document_upload)
    @quantity_surveyor = quantity_surveyor
    @other_document_upload = other_document_upload
  end

  def pdf_viewer?
    owns_documents_request_for_tender?
  end

  def image_viewer?
    owns_documents_request_for_tender?
  end

  def update
    owns_documents_request_for_tender?
  end

  private

  def owns_documents_request_for_tender?
    true if @quantity_surveyor == @other_document_upload.quantity_surveyor
  end
end
