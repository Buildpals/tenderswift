class AddWinnerIdToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :winner_id, :integer
  end
end
