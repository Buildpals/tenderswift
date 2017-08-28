class AddInterestedToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :interested, :boolean
  end
end
