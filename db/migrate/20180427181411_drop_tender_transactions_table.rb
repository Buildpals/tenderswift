class DropTenderTransactionsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table "tender_transactions", force: :cascade do |t|
      t.bigint "request_for_tender_id"
      t.string "customer_number"
      t.decimal "amount"
      t.string "transaction_id"
      t.string "network_code"
      t.integer "status"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "vodafone_voucher_code"
      t.string "card_url"
      t.bigint "tender_id"
      t.index ["request_for_tender_id"], name: "index_tender_transactions_on_request_for_tender_id"
      t.index ["tender_id"], name: "index_tender_transactions_on_tender_id"
    end
  end
end
