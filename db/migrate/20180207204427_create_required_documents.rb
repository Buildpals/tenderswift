class CreateRequiredDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :required_documents do |t|
      t.references :request_for_tender, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
