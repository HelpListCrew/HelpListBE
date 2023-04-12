require "rails_helper"

RSpec.describe Organization do
  describe "relationships" do
    it { should have_many :organization_users }
    it { should have_many(:users).through(:organization_users) }
  end

  describe "validations" do

  end
end