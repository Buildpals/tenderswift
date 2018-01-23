class RemoveContractSumFromParticipant < ActiveRecord::Migration[5.1]
  def change
    remove_column :participants, :contract_sum
  end
end
