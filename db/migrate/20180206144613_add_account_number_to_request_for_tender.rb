class AddAccountNumberToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :account_number, :string
  end
end
