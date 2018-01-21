class AddRowNumberOnRates < ActiveRecord::Migration[5.1]
  def change
    add_column :rates, :row_number, :integer
    add_index :rates, :row_number
  end
end
