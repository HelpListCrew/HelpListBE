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
end