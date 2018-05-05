# frozen_string_literal: true

class RequiredDocumentUploadPolicy
  attr_reader :quantity_surveyor, :required_document_upload

  def initialize(quantity_surveyor, required_document_upload)
    @quantity_surveyor = quantity_surveyor
    @required_document_upload = required_document_upload
  end

  def owns_the_request_for_tender_for_the_required_document?
    owns_documents_request_for_tender?
  end

  def owns_the_request_for_tender_for_the_required_document?
    owns_documents_request_for_tender?
  end

  def owns_the_request_for_tender_for_the_required_document?
    owns_documents_request_for_tender?
  end

  private

  def owns_the_request_for_tender_for_the_required_document?
    true if @quantity_surveyor == @required_document_upload
                                      .tender
                                      .request_for_tender
                                      .quantity_surveyor
  end
end