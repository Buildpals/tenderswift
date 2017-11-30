class RemoveWinnerIdFromRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders, :winner_id
  end
end
