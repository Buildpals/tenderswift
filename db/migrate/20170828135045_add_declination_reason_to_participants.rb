class AddDeclinationReasonToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :declination_reason, :text
  end
end
