class AddContractorToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_reference :participants, :contractor, foreign_key: true
  end
end
