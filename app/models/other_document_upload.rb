class OtherDocumentUpload < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :participant, inverse_of: :other_document_uploads

  validate :check_file_extension

  private

  def check_file_extension
    return unless document
    accepted_formats = %w(.doc .docx .pdf .dwg .dxf .png .jpg .bmp .tiff .svg)
    return if accepted_formats.include? File.extname(document.file.path)
    errors.add(:document, :invalid, message: 'The uploaded document should be a PDF, Word Document, Image or AutoCAD file.')
  end
end
