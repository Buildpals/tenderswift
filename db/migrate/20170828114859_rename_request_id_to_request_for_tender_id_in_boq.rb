class RenameRequestIdToRequestForTenderIdInBoq < ActiveRecord::Migration[5.1]
  def change
    rename_column :boqs, :request_id, :request_for_tender_id
  end
end
