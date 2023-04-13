FactoryBot.define do
  factory :wishlist_item do
    recipient { create(:user, user_type: 1)}
    api_item_id { 1 }
    purchased { false }
    received { false }
  end
end
