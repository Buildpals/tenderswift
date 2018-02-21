class CreateRequiredDocumentUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :required_document_uploads do |t|
      t.string :document
      t.references :participant, foreign_key: true
      t.references :required_document, foreign_key: true
      t.integer :status
      t.timestamps
    end
  end
end
