# frozen_string_literal: true

FactoryBot.define do
  factory :request_for_tender do
    quantity_surveyor
    sequence(:project_name) { |n| "Project #{n} Proposed residential building for Mrs. Christina Love" }
    deadline { DateTime.current + 7.days }
    city 'Kumasi'
    description 'The structure is a one-storey skeleton frames facility with solid sandcrete block walls as partitions. It covers an area of 478sqm'
    country_code 'GH'
    currency 'GHS'

    bill_of_quantities do
      file = File.open(
        Rails.root + 'spec/fixtures/bill_of_quantities.json',
        'rb'
      )
      file.read
    end

    tender_instructions 'Provide the required documents listed above'
    selling_price_subunit 1
    bank_name 'Ecobank'
    branch_name 'A & C Mall'
    account_name 'Christina Construction Services'
    account_number '123456789123456'

    portal_visits 1
    withdrawal_frequency 1
    contract_sum_address nil

    published_time '2018-03-24 08:32:51'

    after(:create) do |request_for_tender|
      # create tender documents (project_documents)
      create_list(:project_document, 7, request_for_tender: request_for_tender)

      # create required_documents
      create_list(:required_document, 9, request_for_tender: request_for_tender)
    end
  end
end
