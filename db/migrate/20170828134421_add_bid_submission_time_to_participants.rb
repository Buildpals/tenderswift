class AddBidSubmissionTimeToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :bid_submission_time, :datetime
  end
end
