require "rails_helper"

RSpec.describe WishlistItem do
  describe "relationships" do
    it { should belong_to :user }
    it { should have_many :user_wishlist_items }
  end

  describe "validations" do

  end
end