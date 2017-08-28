class AddRemovedToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :removed, :boolean
  end
end
