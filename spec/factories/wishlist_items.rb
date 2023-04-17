FactoryBot.define do
  factory :wishlist_item do
    recipient { create(:user, user_type: 1)}
    api_item_id { Faker::Number.within(range: 1..100) }
		image_path { Faker::Internet.url(host: "example.com") }
		price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
		size { Faker::String.random(length: 4) }
		name { Faker::Name.name }
    purchased { false }
    received { false }
  end
end
