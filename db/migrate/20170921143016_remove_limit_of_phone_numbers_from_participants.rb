class RemoveLimitOfPhoneNumbersFromParticipants < ActiveRecord::Migration[5.1]
  def change
    change_column :participants, :phone_number, :string, limit:nil, null: false, default: '+233 50 136 9031'
  end
end
