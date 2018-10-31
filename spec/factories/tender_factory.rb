# frozen_string_literal: true

FactoryBot.define do
  factory :tender do
    request_for_tender
    contractor

    notes {nil}
    score {nil}
    disqualified {false}

    customer_number {'0509825831'}
    amount {nil}
    network_code {'VOD'}
    vodafone_voucher_code {'434335'}

    purchase_request_sent_at {nil}
    purchase_request_status {:pending}
    purchase_request_message {nil}
    purchased_at {nil}

    submitted_at {nil}

    trait :purchased do
      purchase_request_sent_at {Time.current - 2.hours}
      purchase_request_status {1}
      purchase_request_message {'Successful transaction'}
      amount { request_for_tender.selling_price }
      purchased_at {Time.current}
    end

    trait :filled do
      list_of_rates do
        {'Sheet1!E8' => rand(2..3),
         'Sheet1!E11' => rand(21..22),
         'Sheet1!E14' => rand(17..18),
         'Sheet1!E17' => rand(79..81),
         'Sheet1!E20' => rand(14..16),
         'Sheet1!E22' => rand(12..14),
         'Sheet1!E26' => rand(64..66),
         'Sheet1!E35' => rand(430..460),
         'Sheet1!E41' => rand(500..550),
         'Sheet1!E57' => rand(3..4),
         'Sheet1!E66' => rand(7..8),
         'Sheet1!E70' => rand(18..20),
         'Sheet1!E86' => rand(49..51)}
      end
      sequence(:version_number) { |n| n }

      after(:create) do |tender|
        tender.request_for_tender.required_documents.each do |required_document|
          create(:required_document_upload,
                 tender: tender,
                 required_document: required_document)
        end
      end
    end

    trait :submitted do
      list_of_rates do
        {'Sheet1!E8' => rand(2..3),
         'Sheet1!E11' => rand(21..22),
         'Sheet1!E14' => rand(17..18),
         'Sheet1!E17' => rand(79..81),
         'Sheet1!E20' => rand(14..16),
         'Sheet1!E22' => rand(12..14),
         'Sheet1!E26' => rand(64..66),
         'Sheet1!E35' => rand(430..460),
         'Sheet1!E41' => rand(500..550),
         'Sheet1!E57' => rand(3..4),
         'Sheet1!E66' => rand(7..8),
         'Sheet1!E70' => rand(18..20),
         'Sheet1!E86' => rand(49..51)}
      end
      sequence(:version_number) { |n| n }

      after(:create) do |tender|
        tender.request_for_tender.required_documents.each do |required_document|
          create(:required_document_upload,
                 tender: tender,
                 required_document: required_document)
        end
        tender.update!(submitted_at: Time.current - 1.hours)
      end
    end

    factory :purchased_tender, traits: [:purchased]
    factory :filled_tender, traits: %i[purchased filled]
    factory :submitted_tender, traits: %i[purchased submitted]
  end
end
