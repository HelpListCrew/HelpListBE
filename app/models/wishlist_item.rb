class WishlistItem < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  has_one :donor_item
  has_one :donor, through: :donor_items
end
