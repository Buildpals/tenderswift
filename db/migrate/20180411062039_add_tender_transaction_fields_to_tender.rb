class AddTenderTransactionFieldsToTender < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :customer_number, :string
    add_column :tenders, :amount, :decimal
    add_column :tenders, :transaction_id, :string
    add_column :tenders, :network_code, :string
    add_column :tenders, :status, :integer
    add_column :tenders, :vodafone_voucher_code, :string
  end
end
