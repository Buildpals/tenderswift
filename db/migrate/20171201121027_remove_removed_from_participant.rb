class RemoveRemovedFromParticipant < ActiveRecord::Migration[5.1]
  def change
    remove_column :participants, :removed, :boolean
  end
end
