class AddReadToOtherDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :other_document_uploads, :read, :boolean, deault: false
  end
end
