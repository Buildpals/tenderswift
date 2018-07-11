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

    # bill_of_quantities do
    #   file = File.open(
    #     Rails.root + 'spec/fixtures/bill_of_quantities.json',
    #     'rb'
    #   )
    #   file.read
    # end

    list_of_items(
      'items' => [
        { 'name' => '', 'unit' => '', 'isHeader' => true, 'quantity' => '', 'description' => 'Site Preparation' },
        { 'name' => 'A', 'unit' => 'm2', 'quantity' => "1372\t", 'description' => 'Clear site of all vegetation comprising shrubs and tress with gith less than 0.15m' },
        { 'name' => 'B', 'unit' => 'm2', 'quantity' => '1378', 'description' => 'Excavate topsoil for preservation ,average deep 150mm, wheel a distance not exceeding 100m on site' },
        { 'name' => 'C', 'unit' => 'm3', 'quantity' => '204', 'description' => 'Excavate foundation trench , width > 0.3m, maximum depth not exceeding 2.0m' },
        { 'name' => 'D', 'unit' => 'm3', 'quantity' => '208', 'description' => 'Excavate pit (116 Nr), maximum depth not exceeding 2.0m' },
        { 'name' => '', 'unit' => '', 'isHeader' => true, 'quantity' => '', 'description' => 'Earthwork support' },
        { 'name' => 'K', 'unit' => 'm2', 'quantity' => '775', 'description' => 'Earthwork support maximum depth <2m, distance between opposing faces <2m' }
      ],
      'updated_at' => 1_527_537_549_972
    )

    tender_instructions 'Provide the required documents listed above'
    selling_price_subunit 1
    bank_name 'Ecobank'
    branch_name 'A & C Mall'
    account_name 'Christina Construction Services'
    account_number '123456789123456'

    portal_visits 1
    withdrawal_frequency 1
    contract_sum_address nil

    submitted_at '2018-03-24 08:00:51'
    published_at '2018-03-24 08:32:51'

    after(:create) do |request_for_tender|
      # create tender documents (project_documents)
      create_list(:project_document, 7, request_for_tender: request_for_tender)

      # create required_documents
      create_list(:required_document, 9, request_for_tender: request_for_tender)
    end
  end

  factory :empty_request_for_tender, class: RequestForTender do
    sequence(:project_name) { |n| "Project #{n} Proposed residential building for Mrs. Christina Love" }
  end
end
