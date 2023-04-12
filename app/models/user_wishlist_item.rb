class UserWishlistItem < ApplicationRecord
  belongs_to :wishlist_item
  belongs_to :user
end
