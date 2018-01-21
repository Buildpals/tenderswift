class AddAndRemoveParticipantContractSum < ActiveRecord::Migration[5.1]
  def change
    #remove_column :participants, :contract_sum
    add_column :participants, :contract_sum, :float
  end
end
