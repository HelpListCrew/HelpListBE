class User < ApplicationRecord
  has_many :organization_users
  has_many :organizations, through: :organization_users
  has_many :wishlist_items
  has_many :user_wishlist_items
end
