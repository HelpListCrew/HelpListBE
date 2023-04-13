class WishlistItem < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  has_many :user_wishlist_items
end
