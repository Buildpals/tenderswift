class AddReadToRequireDocumentUpload < ActiveRecord::Migration[5.1]
  def change
    add_column :required_document_uploads, :read, :boolean
  end
end
