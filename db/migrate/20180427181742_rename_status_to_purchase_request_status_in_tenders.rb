class RenameStatusToPurchaseRequestStatusInTenders < ActiveRecord::Migration[5.1]
  def change
    rename_column :tenders, :status, :purchase_request_status
  end
end
