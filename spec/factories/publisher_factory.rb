# frozen_string_literal: true

FactoryBot.define do
  factory :publisher do
    company_name do
      [
          'Timcofie Ventures',
          'Mank Company',
          'Jkk Zendo Company',
          'Aurecon',
          'Trana Tek Ghana Limited',
          'Intertek Ghana Limited Gts',
          'Inocon Group Limited',
          'Doyenserve Company Limited',
          'Fxt Construction Limited',
          'Gapson Company Limited',
          'Imperial Realty And Construction Ltd',
          'Asad Construction Limited',
          'De Simone Group',
          'Joshob Construction Limited',
          'Psa Builders',
          'Casapulo Ghana Limited',
          'Ghana Metal Fabrication Construction Ltd',
          'Architectural Externals And General Landscapes',
          'Mac Logistics Limited',
          'Addakus Construction Limited',
          'Rabotec Ghana Limited',
          'Proconsult Limited',
          'Wilkado Construction Works',
          'Asterion Construction Limited',
          'Asanduff Construction Company',
          'Taysec Construction',
          'David Walter Limited',
          'Frederick Williams Construction Limited',
          'Hellenist Construction Co'
      ].sample
    end

    full_name {Faker::Name.name}
    email {Faker::Internet.safe_email}
    phone_number {Faker::PhoneNumber.phone_number}
    password {'password'}
    confirmed_at {Time.current}

    after :create do |q|
      q.update_column(:company_logo,
                      'http://res.cloudinary.com/tenderswift/image/upload/v1519220265/p0bjijzpbadcssih9j3n.png')
    end
  end
end
