# frozen_string_literal: true

FactoryBot.define do
  factory :required_document do
    request_for_tender
    title { generate(:document_title) }
  end

  sequence :document_title do |n|
    titles = [
      'Tax Clearance Certificate',
      'SSNIT Clearance Certificate',
      'Labour Certificate',
      'Power of attorney',
      'Certificate of Incorporation',
      'Certificate of Commencement',
      'Works and Housing certificate',
      'Financial statements (3 years )',
      'Bank Statement or evidence of Funding (letter of credit'
    ]

    titles[n % titles.length]
  end
end
