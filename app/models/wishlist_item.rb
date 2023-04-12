class WishlistItem < ApplicationRecord
  belongs_to :user
  has_many :user_wishlist_items
end
