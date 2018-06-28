class AddOriginalFileNameToOtherDocumentUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :other_document_uploads, :original_file_name, :string
  end
end
