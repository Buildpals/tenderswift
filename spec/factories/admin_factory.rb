FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "test_admin#{n}@buildpals.com" }
    password 'password'
    confirmed_at Time.current
  end
end
