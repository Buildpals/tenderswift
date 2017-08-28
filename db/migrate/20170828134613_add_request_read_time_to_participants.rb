class AddRequestReadTimeToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :request_read_time, :datetime
  end
end
