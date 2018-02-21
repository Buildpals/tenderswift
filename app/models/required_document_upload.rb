class RequiredDocumentUpload < ApplicationRecord
  belongs_to :required_document
  belongs_to :participant
end
