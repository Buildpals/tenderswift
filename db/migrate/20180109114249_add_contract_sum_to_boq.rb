class AddContractSumToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :contract_sum, :float, default: 0.0
  end
end
