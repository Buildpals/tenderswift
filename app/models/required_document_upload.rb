class RequiredDocumentUpload < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :participant, inverse_of: :required_document_uploads
  belongs_to :required_document, inverse_of: :required_document_uploads

  validates :document, presence: true
  validate :check_file_extension

  private

  def check_file_extension
    return unless document
    accepted_formats = %w(.doc .docx .pdf .dwg .dxf .png .jpg .bmp .tiff .svg)
    unless document.file.nil?
      return if accepted_formats.include? File.extname(document.file.path)
      errors.add(:document, :invalid, message: 'The uploaded document should be
                                                a PDF, Word Document, Image or
                                                AutoCAD file.')
    end
  end
end
