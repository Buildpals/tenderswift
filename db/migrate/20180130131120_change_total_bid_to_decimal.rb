class ChangeTotalBidToDecimal < ActiveRecord::Migration[5.1]
  def change
    change_column :participants, :total_bid, :decimal
  end
end
