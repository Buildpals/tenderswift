class CreateAnswerDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_documents do |t|
      t.references :answer_box, foreign_key: true
      t.string :document

      t.timestamps
    end
  end
end
