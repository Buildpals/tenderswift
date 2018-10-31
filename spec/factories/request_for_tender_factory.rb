# frozen_string_literal: true

FactoryBot.define do
  factory :request_for_tender do
    publisher
    sequence(:project_name) { |n| "Project #{n} Proposed residential building for Mrs. Christina Love" }
    deadline { DateTime.current + 7.days }
    city {'Kumasi'}
    description {'The structure is a one-storey skeleton frames facility with solid sandcrete block walls as partitions. It covers an area of 478sqm'}
    country_code {'GH'}

    list_of_items do
      file = File.read(Rails.root + 'spec/fixtures/bill_of_quantities.json')
      JSON.parse(file)
    end

    list_of_rates do
      {'Sheet1!E8' => 2.4,
       'Sheet1!E11' => 21,
       'Sheet1!E14' => 17.5,
       'Sheet1!E17' => 80,
       'Sheet1!E20' => 15,
       'Sheet1!E22' => 13,
       'Sheet1!E26' => 65,
       'Sheet1!E35' => 450,
       'Sheet1!E41' => 520,
       'Sheet1!E57' => 3.5,
       'Sheet1!E66' => 9,
       'Sheet1!E70' => 19,
       'Sheet1!E86' => 50}
    end

    tender_instructions {'Provide the required documents listed above'}
    selling_price_subunit {1}
    bank_name {'Ecobank'}
    branch_name {'A & C Mall'}
    account_name {'Christina Construction Services'}
    account_number {'123456789123456'}

    portal_visits {0}
    withdrawal_frequency {1}
    tender_figure_address {nil}

    submitted_at {'2018-03-24 08:00:51'}
    published_at {'2018-03-24 08:32:51'}

    trait :published do
      published_at {'2018-03-24 08:32:51'}
    end

    trait :not_published do
      published_at {nil}
    end

    trait :submitted do
      submitted_at {'2018-03-24 08:32:51'}
    end

    trait :not_submitted do
      submitted_at {nil}
    end

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
