class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.references :request_for_tender, foreign_key: true
      t.integer :number
      t.string :title
      t.text :description
      t.integer :question_type
      t.boolean :can_attach_documents
      t.boolean :mandatory
      t.text :choices

      t.timestamps
    end
  end
end
