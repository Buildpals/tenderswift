class RenamePurchaseTimeToPurchasedAtInTenders < ActiveRecord::Migration[5.1]
  def change
    rename_column :tenders, :purchase_time, :purchased_at
  end
end
