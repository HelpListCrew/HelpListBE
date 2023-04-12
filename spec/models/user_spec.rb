require "rails_helper"

RSpec.describe User do
  describe "relationships" do
    it { should have_many :organization_users }
    it { should have_many :wishlist_items }
    it { should have_many :user_wishlist_items }
    it { should have_many(:organizations).through(:organization_users) }
  end

  describe "validations" do

  end
end