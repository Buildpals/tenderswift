class DropTransactionTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :transactions
  end
end
