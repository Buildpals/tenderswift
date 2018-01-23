class ChangeAmountColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :boqs, :amount_column, :string, default: "F"
  end
end
