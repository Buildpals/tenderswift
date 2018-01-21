class CreateRates < ActiveRecord::Migration[5.1]
  def change
    
    #drop_table :rates

    create_table :rates do |t|
      t.references :boq
      t.string :sheet_name
      t.integer :row_number
      t.integer :value
      t.timestamps
    end
  end
end
