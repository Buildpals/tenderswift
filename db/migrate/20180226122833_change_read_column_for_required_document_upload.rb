class ChangeReadColumnForRequiredDocumentUpload < ActiveRecord::Migration[5.1]
  def change
    change_column :required_document_uploads, :read, :boolean, default: false
  end
end
