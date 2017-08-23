class CreateParticipantsRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :participants_requests, id: false do |t|
      t.integer :participant_id
      t.integer :request_id
    end
    add_index :participants_requests, :participant_id
    add_index :participants_requests, :request_id
  end
end
