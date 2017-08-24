class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :rate
      t.string :quantity
      t.string :rate
      t.string :amount
      t.references :section
      t.timestamps
    end
  end
end
