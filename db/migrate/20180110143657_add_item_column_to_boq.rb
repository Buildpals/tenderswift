class AddItemColumnToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :item_column, :string
  end
end
