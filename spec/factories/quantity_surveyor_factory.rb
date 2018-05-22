# frozen_string_literal: true

FactoryBot.define do
  factory :quantity_surveyor do
    company_name 'Test Procurement Services'
    full_name 'Test Procurement Officer'
    email do
      'tenderswift_test_procurement_officer+' \
          "#{SecureRandom.urlsafe_base64(6)}@gmail.com".downcase
    end

    phone_number '024 012 3456'
    password 'password'

    after :create do |q|
      q.update_column(:company_logo,
                      'http://res.cloudinary.com/tenderswift/image/upload/v1519220265/p0bjijzpbadcssih9j3n.png')
    end
  end
end
