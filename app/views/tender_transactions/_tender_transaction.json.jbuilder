json.extract! tender_transaction, :id, :customer_number, :amount, :transaction_id, :voucher_code, :network_code, :status, :created_at, :updated_at
json.url tender_transaction_url(tender_transaction, format: :json)
