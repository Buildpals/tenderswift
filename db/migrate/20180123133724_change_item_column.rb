class ChangeItemColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :boqs, :item_column, :string, default: "A"
  end
end
