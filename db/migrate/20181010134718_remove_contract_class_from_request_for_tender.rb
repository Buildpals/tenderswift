class RemoveContractClassFromRequestForTender < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders, :contract_class, :string
  end
end
