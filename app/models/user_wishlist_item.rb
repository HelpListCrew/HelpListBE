class UserWishlistItem < ApplicationRecord
  belongs_to :wishlist_item
  belongs_to :donor, class_name: "User"
end
