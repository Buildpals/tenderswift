class RemovePurchasedFromTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenders, :purchased, :boolean, default: false, null: false
  end
end
