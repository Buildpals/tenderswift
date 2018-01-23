class ChangeQuantityColumnAgain < ActiveRecord::Migration[5.1]
  def change
    change_column :boqs, :quantity_column, :string, default: "C"
  end
end
