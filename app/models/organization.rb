class Organization < ApplicationRecord
  has_many :organization_users, dependent: :destroy
  has_many :users, through: :organization_users

  validates_presence_of :name, :street_address, :city, :state, :phone_number, :website

  validates :zip_code, presence: true, 
                      format: /\A\d{5}\z/

  validates :email, uniqueness: true,
                    presence: true,
                    format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [street_address, city, state, zip_code].compact.join(", ")
  end

  def self.find_orgs_near_me(address, miles)
    Organization.all.near(address, miles)
  end
end
