# frozen_string_literal: true

class ProjectDocument < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :request_for_tender, inverse_of: :project_documents

  validate :check_file_extension

  private

  def check_file_extension
    return unless document

    accepted_formats = %w[.doc .docx .pdf .dwg .dxf]
    return if accepted_formats.include? File.extname(document.file.path)

    errors.add(
      :document,
      :invalid,
      message: 'The uploaded document should be a PDF, Word Document or AutoCAD file.'
    )
  end
end
