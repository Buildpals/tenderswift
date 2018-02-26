class RequiredDocumentUpload < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :participant, inverse_of: :required_document_uploads
  belongs_to :required_document, inverse_of: :required_document_uploads

  validates :document, presence: true
  validate :check_file_extension

  enum status: { issue: 0, approved: 1 }

  private

  def check_file_extension
    return unless document
    accepted_formats = %w(.pdf .jpeg .png .jpg)
    unless document.file.nil?
      return if accepted_formats.include? File.extname(document.filename)
      errors.add(:document, :invalid, message: 'The uploaded document should be
                                                a PDF or an Image. Thank you!')
    end
  end
end
