# frozen_string_literal: true

class RequiredDocumentUpload < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :tender, inverse_of: :required_document_uploads
  belongs_to :required_document, inverse_of: :required_document_uploads

  validate :check_file_extension

  validate :check_file_size

  enum status: { pending: 0, approved: 1, rejected: 2 }

  delegate :publisher, to: :tender
  delegate :title, to: :required_document

  private

  def check_file_extension
    return unless document
    accepted_formats = %w[.pdf .jpeg .png .jpg]

    if document.file.nil?
      true
    else
      return if accepted_formats.include? File.extname(document.filename)
      errors.add(:document, 'must be a pdf or an image file.')
    end
  end

  def check_file_size
    errors.add(:document, :invalid, message: 'The uploaded file size should be less '\
                                              'than 10MB') if document.file.size > 10.megabytes
  end
end
