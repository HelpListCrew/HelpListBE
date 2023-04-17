FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr}
    zip_code { Faker::Address.zip[0..4] }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    website { Faker::Internet.url(host: 'example.com') }
    mission_statement { Faker::Lorem.paragraph }
  end
end
