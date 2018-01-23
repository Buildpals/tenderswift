class ChangeQuantityColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :boqs, :rate_column, :string, default: "C"
  end
end
