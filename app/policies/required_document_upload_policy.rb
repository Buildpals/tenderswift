# frozen_string_literal: true

class RequiredDocumentUploadPolicy
  attr_reader :quantity_surveyor, :required_document_upload

  def initialize(quantity_surveyor, required_document_upload)
    @quantity_surveyor = quantity_surveyor
    @required_document_upload = required_document_upload
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
    true if @quantity_surveyor == @required_document_upload.quantity_surveyor
  end
end
