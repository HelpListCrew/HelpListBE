require "rails_helper"

RSpec.describe OrganizationUser do
  describe "relationships" do
    it { should belong_to :organization }
    it { should belong_to :user }
  end

  describe "validations" do

  end
end