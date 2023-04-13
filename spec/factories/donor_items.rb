FactoryBot.define do
  factory :donor_item do
    wishlist_item
    donor { create(:user) }
  end
end
