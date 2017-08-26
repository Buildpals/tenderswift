class Excel < ApplicationRecord

  mount_uploader :document, DocumentUploader
  
  belongs_to :request


end
