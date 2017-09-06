class ProjectDocument < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :request_for_tender

  validate :check_file_extension

  private

  def check_file_extension
    if document
      accepted_formats = ['.docx', '.pdf', '.dwg', '.dxf']
      unless accepted_formats.include? File.extname(document.file.path)
        errors.add(:document, :invalid, message: "The uploaded document should be a PDF, Word Document or Auto Card file.")
      end
    end
  end
  
end
