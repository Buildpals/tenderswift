# frozen_string_literal: true

FactoryBot.define do
  factory :other_document_upload do
    title 'Testing'

    after :create do |b|
      b.update_column(
          :document,
          'v1523878640/Contract_Documents_t7efwx.doc'
      )
    end
  end
end
