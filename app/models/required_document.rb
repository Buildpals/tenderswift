class RequiredDocument < ApplicationRecord
  belongs_to :request_for_tender, inverse_of: :required_documents
  has_many :required_document_uploads
end
