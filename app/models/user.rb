class User < ApplicationRecord
  has_many :organization_users
  has_many :organizations, through: :organization_users
  has_many :wishlist_items, foreign_key: :recipient_id, inverse_of: :recipient
  has_many :donor_items, foreign_key: :donor_id, dependent: :destroy

  enum user_type: ["donor", "recipient"]

  validates :email, uniqueness: true,
                    presence: true,
                    format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates_presence_of :password

  has_secure_password
end
