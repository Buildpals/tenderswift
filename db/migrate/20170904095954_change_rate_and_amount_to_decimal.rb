class ChangeRateAndAmountToDecimal < ActiveRecord::Migration[5.1]
  def change
    remove_column :filled_items, :rate
    remove_column :filled_items, :amount

    add_column :filled_items, :rate, :decimal, precision: 10, scale: 2
    add_column :filled_items, :amount, :decimal, precision: 10, scale: 2
  end
end
