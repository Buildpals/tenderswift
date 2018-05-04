class RenameNameToTitleInOtherDocumentUpload < ActiveRecord::Migration[5.1]
  def change
    rename_column :other_document_uploads, :name, :title
  end
end
