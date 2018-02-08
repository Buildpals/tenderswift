class AddBankNameToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :bank_name, :string
  end
end
