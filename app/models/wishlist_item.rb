class WishlistItem < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  has_many :donor_items
end
