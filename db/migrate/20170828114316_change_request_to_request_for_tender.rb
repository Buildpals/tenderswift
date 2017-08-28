class ChangeRequestToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    rename_table :requests, :request_for_tenders
  end
end
