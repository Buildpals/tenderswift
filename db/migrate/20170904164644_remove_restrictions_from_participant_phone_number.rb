class RemoveRestrictionsFromParticipantPhoneNumber < ActiveRecord::Migration[5.1]
  def change
    change_column :participants, :phone_number, :string
  end
end
