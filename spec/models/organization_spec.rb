require "rails_helper"

RSpec.describe Organization do
  describe "relationships" do
    it { should have_many :organization_users }
    it { should have_many(:users).through(:organization_users) }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street_address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip_code }
    it { should validate_presence_of :website }

    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }

    it { should validate_presence_of :phone_number }
  end

  describe "Instance Methods" do
    it "full_address" do
      library = create(:organization, name: "Library", street_address: "201 Peterson St.", city: "Fort Collins", state: "CO", zip_code: "80524" )
      expect(library.full_address).to eq("201 Peterson St., Fort Collins, CO, 80524")
    end
  end

  describe "Class Methods" do
    describe "find_orgs_near_me" do
      it "sorts orgs by distance from a given address and number of miles radius" do
        library = create(:organization, name: "Library", street_address: "201 Peterson St.", city: "Fort Collins", state: "CO", zip_code: "80524" )
        dia = create(:organization, name: "Airport", street_address: "8500 Peña Blvd", city: "Denver", state: "CO", zip_code: "80249")
        hospital = create(:organization, name: "Hospital", street_address: "1024 S. Lemay Ave.", city: "Fort Collins", state: "CO", zip_code: "80524")
        cityhall = create(:organization, name: "City Hall", street_address: "300 Laporte Ave", city: "Fort Collins", state: "CO", zip_code: "80521")
        zoo = create(:organization, name: "Denver Zoo", street_address: "2300 Steele St", city: "Denver", state: "CO", zip_code: "80205")
        
        averyhouse = "200 W Oak St, Fort Collins, CO 80521"
        aquarium = "700 Water St, Denver, CO 80211"

        expect(Organization.find_orgs_near_me(averyhouse, 300)).to match([cityhall, library, hospital, dia, zoo])
        expect(Organization.find_orgs_near_me(aquarium, 50)).to match([zoo, dia])
      end
    end
  end
end