class RemoveAmountFromFilledItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :filled_items, :amount, :decimal, precision: 10, scale: 2
  end
end
