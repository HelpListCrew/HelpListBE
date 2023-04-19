require "rails_helper"

RSpec.describe WishlistItem do
  describe "relationships" do
    it { should belong_to :recipient }
    it { should have_one :donor_item }
  end

  describe "validations" do
    it { should validate_presence_of :api_item_id }
    it { should validate_presence_of :recipient_id }
    it { should validate_numericality_of :api_item_id }
  end

  describe "#instance methods" do
    describe "#by_user" do
      it "returns all wishlist items for a specific user" do
        user_1 = create(:user, user_type: 1)
        user_2 = create(:user, user_type: 1)

        create_list(:wishlist_item, 3, recipient: user_1, purchased: true)
        create(:wishlist_item, recipient: user_1, purchased: false)
        create(:wishlist_item, recipient: user_1, purchased: false)
        
        create_list(:wishlist_item, 3, recipient: user_2, purchased: true)
        
        expect(WishlistItem.count).to eq(8)

        expect(WishlistItem.by_user(user_1.id).count).to eq(5)
      end
    end

    describe "#unpurchased_by_user" do
      it "returns all unpurchased wishlist items for a specific user" do
        user = create(:user, user_type: 1)
        create_list(:wishlist_item, 3, recipient: user, purchased: true)
        create(:wishlist_item, recipient: user, purchased: false)
        create(:wishlist_item, recipient: user, purchased: false)

        expect(WishlistItem.count).to eq(5)

        expect(WishlistItem.unpurchased_by_user(user.id).count).to eq(2)
      end
    end

    describe "#donated_items" do
      it "returns all donated items for a specific user" do
        donor_1 = create(:user)
        donor_2 = create(:user)
        recipient = create(:user, user_type: 1)

        create_list(:wishlist_item, 3, recipient: recipient, purchased: true)
        create(:wishlist_item, recipient: recipient, purchased: true)
        create_list(:wishlist_item, 5, recipient: recipient, purchased: false)

        create(:donor_item, donor: donor_1, wishlist_item: WishlistItem.first)
        create(:donor_item, donor: donor_1, wishlist_item: WishlistItem.second)
        create(:donor_item, donor: donor_1, wishlist_item: WishlistItem.third)
        create(:donor_item, donor: donor_2, wishlist_item: WishlistItem.fourth)
       
        expect(WishlistItem.donated_items(donor_1.id).count).to eq(3)

        WishlistItem.donated_items(donor_1.id).each do |donated_item|
          expect(donated_item).to be_a(WishlistItem)
        end
      end
    end
  end
end