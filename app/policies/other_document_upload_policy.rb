# frozen_string_literal: true

class OtherDocumentUploadPolicy
  attr_reader :quantity_surveyor, :other_document_upload

  def initialize(quantity_surveyor, other_document_upload)
    @quantity_surveyor = quantity_surveyor
    @other_document_upload = other_document_upload
  end

  def show?
    owns_documents_request_for_tender?
  end

  def approve?
    owns_documents_request_for_tender?
  end

  def reject?
    owns_documents_request_for_tender?
  end

  private

  def owns_documents_request_for_tender?
    true if @quantity_surveyor == @other_document_upload.quantity_surveyor
  end
end
