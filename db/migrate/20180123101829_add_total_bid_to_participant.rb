class AddTotalBidToParticipant < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :total_bid, :float, default: 0.0
  end
end
