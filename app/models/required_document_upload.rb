class RequiredDocumentUpload < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :participant, inverse_of: :required_document_uploads
  belongs_to :required_document, inverse_of: :required_document_uploads

  validate :check_file_extension, on: :create

  validates :document, presence: true

  enum status: { issue: 0, approved: 1 }

  private

  def check_file_extension
    return unless document
    accepted_formats = %w(application/pdf image/jpeg image/png image/jpg)
    unless document.file.nil?
      return if accepted_formats.include? document.file.content_type
      errors.add(:document, :invalid, message: 'The uploaded document should be
                                                a PDF or an Image. Thank you!')
    end
  end
end
