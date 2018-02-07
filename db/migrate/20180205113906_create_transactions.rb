class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :customer_number, limit: 10
      t.decimal :amount
      t.string :network
      t.string :transaction_code
      t.string :voucher_code
      t.timestamps
    end
  end
end
