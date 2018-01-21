class AddAmountColumnToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :amount_column, :string
  end
end
