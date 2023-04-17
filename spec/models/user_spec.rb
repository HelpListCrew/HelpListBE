require "rails_helper"

RSpec.describe User do
  describe "relationships" do
    it { should have_many :organization_users }
    it { should have_many :wishlist_items }
    it { should have_many :donor_items }
    it { should have_many(:organizations).through(:organization_users) }
  end

  describe "validations" do
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :email }
		it { should validate_presence_of :password }

    it "should validate that it's a properly formatted email" do
      john = User.new(email: "jsmith@gmail.com", password: "password")
      expect(john.valid?).to be(true)
   
      john = User.new(email: "fasd324223", password: "password")
      expect(john.valid?).to be(false)
     end
  end

  describe "Class Methods" do
    it "find_recipient_by_username" do
      user1 = create(:user, email: "helloyou@elsewhere.com", username: "electric_emerald",user_type: 1)
      user2 = create(:user, email: "hellothere@somewhere.net", username: "ocianic_dreamer", user_type: 1)
      user3 = create(:user, email: "otherhello@everywhere.org", username: "electric_tiger", user_type: 1)
      user4 = create(:user, email: "goodbye@nowhere.edu", username: "ocean_mermaid", user_type: 1)

      expect(User.find_recipient_by_username("oCeAn")).to eq([user4])
      expect(User.find_recipient_by_username("oCeAn")).to_not eq([user1])

      expect(User.find_recipient_by_username("elec")).to eq([user1, user3])
      expect(User.find_recipient_by_username("elec")).to_not eq([user2, user4])
    end
  end
end