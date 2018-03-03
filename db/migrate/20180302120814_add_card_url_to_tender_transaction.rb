class AddCardUrlToTenderTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :tender_transactions, :card_url, :string
  end
end
