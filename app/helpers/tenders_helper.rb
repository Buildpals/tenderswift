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

  def contractor_tab(tender, wizard_step, index)
      if !tender.submitted_at.nil? && wizard_step.eql?(:upload_documents)
         return link_to "#{index + 1}. Uploaded Documents",
                wizard_path(wizard_step),
                class: "nav-item nav-link #{'active' if step == wizard_step}"
      else
         return link_to "#{index + 1}. #{wizard_step.to_s.humanize}",
                  wizard_path(wizard_step),
                  class: "nav-item nav-link #{'active' if step == wizard_step}"
      end
  end
end
