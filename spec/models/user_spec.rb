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
    it "find_recipient_by_email" do
      user1 = create(:user, email: "helloyou@elsewhere.com", user_type: 1)
      user2 = create(:user, email: "hellothere@somewhere.net", user_type: 1)
      user3 = create(:user, email: "otherhello@everywhere.org", user_type: 1)
      user4 = create(:user, email: "goodbye@nowhere.edu", user_type: 1)
      user5 = create(:user, email: "helloitsme@there.com", user_type: 0)

      expect(User.find_recipient_by_email("hELlo")).to eq([user2, user1, user3])
      expect(User.find_recipient_by_email("hELlo")).to_not eq([user4])
      expect(User.find_recipient_by_email("hELlo")).to_not eq([user5])
    end
  end
end