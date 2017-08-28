class RenameRequestIdToRequestForTenderId < ActiveRecord::Migration[5.1]
  def change
    rename_column :participants_requests, :request_id, :request_for_tender_id
  end
end
