class AddOriginalFileNameToProjectDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :project_documents, :original_file_name, :string
  end
end
