class AddContractSumToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :contract_sum, :string
    add_column :request_for_tenders, :contract_sum_currency, :string, default: 'USD', null: false
  end
end
