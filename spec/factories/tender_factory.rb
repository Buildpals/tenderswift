FactoryBot.define do
  factory :tender do
    request_for_tender
    auth_token '123hgfhdhgdhdss'
    purchased false
    submitted false
    purchase_time Time.new
    submitted_time Time.new
    read false
    rating nil
    disqualified false
    notes nil
    contractor
    customer_number '0509825831'
    amount 100.00
    transaction_id '$7857&#45'
    network_code 'VOD'
    status 'pending'
    vodafone_voucher_code '434335'
  end
end