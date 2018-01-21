class AddQuantityColumnToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :quantity_column, :string
  end
end
