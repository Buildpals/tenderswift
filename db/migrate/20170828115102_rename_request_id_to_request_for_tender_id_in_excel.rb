class RenameRequestIdToRequestForTenderIdInExcel < ActiveRecord::Migration[5.1]
  def change
    rename_column :excels, :request_id, :request_for_tender_id
  end
end
