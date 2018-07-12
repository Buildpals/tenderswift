# frozen_string_literal: true

module TendersHelper
  def setup_tender(tender)
    tender.required_documents.each do |required_document|
      next if tender.required_document_upload?(required_document)

      tender.required_document_uploads
            .build(required_document: required_document)
    end
    tender
  end
end
