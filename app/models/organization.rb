class Organization < ApplicationRecord
  has_many :organization_users
  has_many :users, through: :organization_users

  validates_presence_of :name, :street_address, :city, :state, :zip_code, :email, :phone_number, :website
end
