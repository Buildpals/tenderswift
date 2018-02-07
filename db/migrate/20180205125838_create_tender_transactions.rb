class CreateTenderTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :tender_transactions do |t|
      t.string :customer_number
      t.decimal :amount
      t.string :transaction_id
      t.string :voucher_code
      t.string :network_code
      t.integer :status
      t.timestamps
    end
  end
end
