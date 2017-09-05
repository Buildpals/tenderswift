class AddDefaultItemTypeForItem < ActiveRecord::Migration[5.1]
  def change
    change_column_default :items, :item_type, 0
  end
end
