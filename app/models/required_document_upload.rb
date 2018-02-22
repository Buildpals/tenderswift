class RequiredDocumentUpload < ApplicationRecord
  mount_uploader :document, DocumentUploader
  belongs_to :required_document
  belongs_to :participant
end
