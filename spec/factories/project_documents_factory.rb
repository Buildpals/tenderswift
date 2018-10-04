# frozen_string_literal: true

FactoryBot.define do
  factory :project_document do
    request_for_tender

    # document do
    #   Rack::Test::UploadedFile.new(
    #     Rails.root + 'spec/fixtures/Contract Documents.doc',
    #     'application/msword'
    #   )
    # end

    after :create do |b|
      b.update_column(
          :document,
          'v1523878640/Contract_Documents_t7efwx.doc'
      )
    end
  end
end
