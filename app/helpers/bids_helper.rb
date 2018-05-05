# frozen_string_literal: true

module BidsHelper
  include ActionView::Helpers::DateHelper

  def uploaded_document_url(uploaded_document)
    if uploaded_document.class == RequiredDocumentUpload
      required_document_upload_path(uploaded_document)
    else
      other_document_upload_path(uploaded_document)
    end
  end
end
