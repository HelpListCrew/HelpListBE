FactoryBot.define do
  factory :wishlist_item do
    user { nil }
    api_item_id { 1 }
    purchased { false }
    received { false }
  end
end
