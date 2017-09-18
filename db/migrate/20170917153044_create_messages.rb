class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :broadcast_message, foreign_key: true
      t.references :participant, foreign_key: true
      t.timestamps
    end
  end
end
