# frozen_string_literal: true

FactoryBot.define do
  factory :required_document_upload do
    required_document

    status {0}
    after :create do |b|
      b.update_column(
          :document,
          'v1523878640/Contract_Documents_t7efwx.doc'
      )
    end
  end
end
