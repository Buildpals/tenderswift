class RemoveInterestedFromParticipants < ActiveRecord::Migration[5.1]
  def change
    remove_column :participants, :interested, :boolean
  end
end
