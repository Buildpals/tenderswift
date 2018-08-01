# frozen_string_literal: true

class OtherDocumentUpload < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :tender, inverse_of: :other_document_uploads

  validate :check_file_extension

  validates :title, presence: true

  enum status: { pending: 0, approved: 1, rejected: 2 }

  delegate :publisher, to: :tender

  private

  def check_file_extension
    return unless document

    accepted_formats = %w[.pdf .jpeg .png .jpg]

    if document.file.nil?
      true
    else
      return if accepted_formats.include? File.extname(document.filename)
      errors.add(
        :document,
        :invalid,
        message: 'The uploaded document should be a PDF or an Image. Thank you!'
      )
    end
  end
end
