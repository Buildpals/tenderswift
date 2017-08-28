class CreateFilledItems < ActiveRecord::Migration[5.1]
  def change
    create_table :filled_items do |t|
      t.string :amount
      t.string :rate
      t.references :participant, foreign_key: true
      t.references :item, foreign_key: true
      t.timestamps
    end
  end
end
