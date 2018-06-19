# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :contractor do
    company_name 'Test Construction Limited'
    full_name 'Test Contractor'

    email do
      'tenderswift_test_contractor+' \
          "#{SecureRandom.urlsafe_base64(6)}@gmail.com".downcase
    end

    phone_number '050 001 1505'
    password 'password'
    confirmed_at Time.current

    status 'active'

    after :create do |q|
      q.update_column(:company_logo,
                      'http://res.cloudinary.com/tenderswift/image/upload/v1519220265/p0bjijzpbadcssih9j3n.png')
    end
  end
end
