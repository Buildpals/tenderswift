class RemoveTransactionIdFromTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenders, :transaction_id, :string
  end
end
