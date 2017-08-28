class AddLastNameToParticipant < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :last_name, :string
  end
end
