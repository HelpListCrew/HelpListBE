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
end