require "rails_helper"

RSpec.describe User do
  describe "relationships" do
    it { should have_many :organization_users }
    it { should have_many :wishlist_items }
    it { should have_many :user_wishlist_items }
    it { should have_many(:organizations).through(:organization_users) }
  end

  describe "validations" do
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :email }

    it "should validate that it's a properly formatted email" do
      john = User.new(email: "jsmith@gmail.com", password: "password")
      expect(john.valid?).to be(true)
   
      john = User.new(email: "fasd324223", password: "password")
      expect(john.valid?).to be(false)
     end
  end
end