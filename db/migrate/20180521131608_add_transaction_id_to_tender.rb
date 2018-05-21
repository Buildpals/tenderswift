class AddTransactionIdToTender < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :transaction_id, :string
  end
end
