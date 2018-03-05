class AddContractSumAddressToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :contract_sum_address, :text
    remove_column :request_for_tenders, :contract_sum_location, :string
  end
end
