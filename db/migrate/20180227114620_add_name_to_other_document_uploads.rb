class AddNameToOtherDocumentUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :other_document_uploads, :name, :string
  end
end
