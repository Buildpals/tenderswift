# frozen_string_literal: true

class OtherDocumentUploadPolicy
  attr_reader :quantity_surveyor, :other_document_upload

  def initialize(quantity_surveyor, other_document_upload)
    @quantity_surveyor = quantity_surveyor
    @other_document_upload = other_document_upload
  end

  def show?
    owns_the_request_for_tender_for_the_other_document? &&
        @other_document_upload.tender.reviewable?
  end

  def approve?
    owns_the_request_for_tender_for_the_other_document? &&
        @other_document_upload.tender.reviewable?
  end

  def reject?
    owns_the_request_for_tender_for_the_other_document? &&
        @other_document_upload.tender.reviewable?
  end

  private

  def owns_the_request_for_tender_for_the_other_document?
    true if @quantity_surveyor == @other_document_upload
                                      .tender
                                      .request_for_tender
                                      .quantity_surveyor
  end
end