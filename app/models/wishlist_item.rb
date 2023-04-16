class WishlistItem < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  has_one :donor_item, dependent: :destroy
  has_one :donor, through: :donor_items

  validates_presence_of :api_item_id, :recipient_id
  validates_numericality_of :api_item_id

	def self.by_user(id)
		where(recipient_id: id)
	end
end
