class OtherDocumentUpload < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :participant, inverse_of: :other_document_uploads

  validate :check_file_extension

  enum status: { issue: 0, approved: 1 }

  private

  def check_file_extension
    return unless document
    accepted_formats = %w(.pdf .jpeg .png .jpg)
    if document.file.nil?
      true
    else
      return if accepted_formats.include? File.extname(document.filename)
      errors.add(:document, :invalid, message: 'The uploaded document should be
                                                a PDF or an Image. Thank you!')
    end
  end
end
