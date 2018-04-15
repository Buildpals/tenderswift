FactoryBot.define do
  factory :request_for_tender do
    quantity_surveyor
    project_name "MyString"
    deadline "2018-03-24 08:32:51"
    city "Kumasi"
    description "MyString"
    country_code "GH"
    currency "MyString"
    bill_of_quantities "MyText"
    tender_instructions "MyText"
    selling_price_subunit 1
    bank_name "Ecobank"
    branch_name "A & C Mall"
    account_name "MyString"
    account_number "MyString"
    private false
    portal_visits 1
    withdrawal_frequency 1
    contract_sum_address nil
    published false
    published_time "2018-03-24 08:32:51"
  end
end
