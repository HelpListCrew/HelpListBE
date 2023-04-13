FactoryBot.define do
  factory :wishlist_item do
    recipient { create(:user, user_type: 1)}
    api_item_id { Faker::Number.within(range: 1..100) }
    purchased { false }
    received { false }
  end
end
