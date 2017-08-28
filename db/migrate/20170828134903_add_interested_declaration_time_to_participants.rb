class AddInterestedDeclarationTimeToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :interested_declaration_time, :datetime
  end
end
