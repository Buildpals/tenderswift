class AddQuantityToRates < ActiveRecord::Migration[5.1]
  def change
    add_column :rates, :quantity, :float
  end
end
