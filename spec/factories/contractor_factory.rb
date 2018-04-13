FactoryBot.define do
  factory :contractor do
    sequence(:company_name) { |n| "Test #{n} Construction Limited" }
    sequence(:full_name) { |n| "Test Anane #{n}" }
    sequence(:email) { |n| "test#{n}@gmail.com" }
    sequence(:phone_number) { |n| "024012345#{n}" }
    password 'password'
    confirmed_at Time.current

    after :create do |q|
      q.update_column(:company_logo,
                      'http://res.cloudinary.com/tenderswift/image/upload/v1519220265/p0bjijzpbadcssih9j3n.png')
    end
  end
end
