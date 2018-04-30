class AddPurchaseRequestMessageToTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :purchase_request_message, :string
  end
end
