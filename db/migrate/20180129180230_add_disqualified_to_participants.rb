class AddDisqualifiedToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :disqualified, :boolean, null: false, default: false
  end
end
