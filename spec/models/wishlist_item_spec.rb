require "rails_helper"

RSpec.describe WishlistItem do
  describe "relationships" do
    it { should belong_to :recipient }
    it { should have_one :donor_item }
  end

  describe "validations" do

  end
end