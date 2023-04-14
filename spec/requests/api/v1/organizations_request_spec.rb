require "rails_helper"

RSpec.describe "Organizations Request" do
  describe "Index Organization" do
    context "when successful" do
      it "retrieves all organizations" do
        create_list(:organization, 3)

        get api_v1_organizations_path

        parsed_organizations = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_organizations[:data]).to be_an(Array)
        expect(parsed_organizations[:data].count).to eq(3)
        
        attribute_keys = [:name, :street_address, :city, :state, :zip_code, :email, :phone_number, :website]
        
        parsed_organizations[:data].each do |parsed_organization|
          expect(parsed_organization.keys).to eq([:id, :type, :attributes])
          expect(parsed_organization[:type]).to eq("organization")

          expect(parsed_organization[:attributes].keys).to eq(attribute_keys)
          expect(parsed_organization[:attributes][:name]).to be_a(String)
          expect(parsed_organization[:attributes][:street_address]).to be_a(String)
          expect(parsed_organization[:attributes][:city]).to be_a(String)
          expect(parsed_organization[:attributes][:state]).to be_a(String)
          expect(parsed_organization[:attributes][:zip_code]).to be_a(String)
          expect(parsed_organization[:attributes][:email]).to be_a(String)
          expect(parsed_organization[:attributes][:phone_number]).to be_a(String)
          expect(parsed_organization[:attributes][:website]).to be_a(String)
        end
      end
    end
  end

  describe "Show Organization" do
    context "when successful" do
      it "retrieves a specific organization" do
        organization = create(:organization)

        get api_v1_organization_path(organization)

        parsed_organization = JSON.parse(response.body, symbolize_names: true)
        # binding.pry
        expect(parsed_organization[:data]).to be_a(Hash)
				expect(parsed_organization[:data].keys).to eq([:id, :type, :attributes])
				expect(parsed_organization[:data][:id]).to eq(organization.id.to_s)
				expect(parsed_organization[:data][:type]).to eq("organization")

				expect(parsed_organization[:data][:attributes].size).to eq(8)
				expect(parsed_organization[:data][:attributes][:name]).to be_a(String)
        expect(parsed_organization[:data][:attributes][:street_address]).to be_a(String)
        expect(parsed_organization[:data][:attributes][:city]).to be_a(String)
        expect(parsed_organization[:data][:attributes][:state]).to be_a(String)
        expect(parsed_organization[:data][:attributes][:zip_code]).to be_a(String)
        expect(parsed_organization[:data][:attributes][:email]).to be_a(String)
        expect(parsed_organization[:data][:attributes][:phone_number]).to be_a(String)
        expect(parsed_organization[:data][:attributes][:website]).to be_a(String)
      end
    end

    context "when unsuccessful" do
      it "sends a 404 status error when organization id not found" do
        get api_v1_organization_path(0)

        parsed_wishlist_item = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(parsed_wishlist_item[:message]).to eq("your query could not be completed")
        expect(parsed_wishlist_item[:errors].count).to eq(1)
        expect(parsed_wishlist_item[:errors].first[:status]).to eq("404")
        expect(parsed_wishlist_item[:errors].first[:title]).to eq("Couldn't find Organization with 'id'=0")
      end
    end
  end
end