# frozen_string_literal: true

FactoryBot.define do
  factory :tender do
    request_for_tender
    contractor

    read false
    notes nil
    rating nil
    disqualified false

    customer_number '0509825831'
    amount 100.00
    network_code 'VOD'
    vodafone_voucher_code '434335'

    purchase_request_sent_at nil
    purchase_request_status :pending
    purchase_request_message nil
    purchased_at nil

    submitted_at nil


    trait :purchased do
      purchase_request_sent_at Time.current - 2.hours
      purchase_request_status :success
      purchase_request_message 'Successful transaction'
      amount { request_for_tender.selling_price }
      purchased_at Time.current
    end

    trait :submitted do
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
    factory :submitted_tender, traits: %i[purchased submitted]
  end
end
