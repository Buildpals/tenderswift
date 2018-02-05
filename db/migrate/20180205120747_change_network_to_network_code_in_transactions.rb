class ChangeNetworkToNetworkCodeInTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :network
    add_column :transactions, :network_code, :string
  end
end
