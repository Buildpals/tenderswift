class AddPurchaseRequestSentAtToTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :purchase_request_sent_at, :datetime
  end
end
