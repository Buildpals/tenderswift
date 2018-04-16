# frozen_string_literal: true

class ProjectDocument < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :request_for_tender, inverse_of: :project_documents

  validate :check_file_extension

  private

  def check_file_extension
    return if document.file.nil?

    extension = File.extname(document.file.path)
    accepted_formats = %w[.doc .docx .pdf .dwg .dxf]
    return if accepted_formats.include?(extension)

    errors.add(
      :document,
      :invalid,
      message: 'The uploaded document should be a PDF, Word Document or AutoCAD file.'
    )
  end
end
