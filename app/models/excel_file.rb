class ExcelFile < ApplicationRecord
  mount_uploader :document, DocumentUploader
  belongs_to :request_for_tender
end
