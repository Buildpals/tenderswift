class CreateAnswerBoxes < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_boxes do |t|
      t.references :question, foreign_key: true
      t.references :participant, foreign_key: true
      t.string :answer

      t.timestamps
    end
  end
end
