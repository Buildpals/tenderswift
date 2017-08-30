class CreateProjectDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :project_documents do |t|
      t.string :document
      t.references :request_for_tender, foreign_key: true

      t.timestamps
    end
  end
end
