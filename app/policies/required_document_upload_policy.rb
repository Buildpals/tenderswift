# frozen_string_literal: true

class RequiredDocumentUploadPolicy
  attr_reader :publisher, :required_document_upload

  def initialize(publisher, required_document_upload)
    @publisher = publisher
    @required_document_upload = required_document_upload
  end

  def show?
    owns_the_request_for_tender_for_the_required_document? &&
        @required_document_upload.tender.reviewable?
  end

  def approve?
    owns_the_request_for_tender_for_the_required_document? &&
        @required_document_upload.tender.reviewable?
  end

  def reject?
    owns_the_request_for_tender_for_the_required_document? &&
        @required_document_upload.tender.reviewable?
  end

  private

  def owns_the_request_for_tender_for_the_required_document?
    true if @publisher == @required_document_upload
                                      .tender
                                      .request_for_tender
                                      .publisher
  end
end