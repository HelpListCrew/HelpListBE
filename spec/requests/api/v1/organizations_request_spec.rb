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

  describe "Create Organization" do
    context "when successful" do
      it "creates a new organization" do
        organization_params = ({
                                name: "name",
                                street_address: "street_address",
                                city: "city",
                                state: "state",
                                zip_code: "zip_code",
                                email: "email",
                                phone_number: "phone_number",
                                website: "website"
                              })

        headers = { "CONTENT_TYPE" => "application/json" }

        post api_v1_organizations_path, headers: headers, params: JSON.generate(organization: organization_params)

        created_organization = Organization.last

        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(created_organization.name).to eq("name")
        expect(created_organization.street_address).to eq("street_address")
        expect(created_organization.city).to eq("city")
        expect(created_organization.state).to eq("state")
        expect(created_organization.zip_code).to eq("zip_code")
        expect(created_organization.email).to eq("email")
        expect(created_organization.phone_number).to eq("phone_number")
        expect(created_organization.website).to eq("website")
      end
    end

    context "when unsuccessful" do
      it "returns 400 error when missing at least one but not all params" do
        organization_params = ({
                                street_address: "street_address",
                                city: "city",
                                state: "state",
                                zip_code: "zip_code",
                                phone_number: "phone_number",
                                website: "website"
                              })

        headers = { "CONTENT_TYPE" => "application/json" }

        post api_v1_organizations_path, headers: headers, params: JSON.generate(organization: organization_params)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body.keys).to match([:message, :errors])
        expect(response_body[:message]).to eq("your query could not be completed")
        expect(response_body[:errors].first[:status]).to eq("400")
        expect(response_body[:errors].first[:title]).to eq("Name can't be blank")
        expect(response_body[:errors].second[:status]).to eq("400")
        expect(response_body[:errors].second[:title]).to eq("Email can't be blank")
      end

      it "returns 400 error when no params are passed" do
        post api_v1_organizations_path

        response_body = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to_not be_successful

        expect(response_body.keys).to match([:message, :errors])
        expect(response_body[:message]).to eq("your query could not be completed")
        expect(response_body[:errors].first[:status]).to eq("400")
        expect(response_body[:errors].first[:title]).to eq("param is missing or the value is empty: organization")
      end
    end
  end

  describe "Update Organization" do
    before(:each) do
      @organization = create(:organization)
    end
    context "when successful" do
      it "updates an existing organization" do
        organization_params = ({
                                name: "new_name",
                                street_address: "new_street_address",
                                city: "new_city",
                                state: "new_state",
                                zip_code: "new_zip_code",
                                email: "new_email",
                                phone_number: "new_phone_number",
                                website: "new_website"
                              })
        
        headers = { "CONTENT_TYPE" => "application/json" }

        patch api_v1_organization_path(@organization), headers: headers, params: JSON.generate(organization: organization_params)

        updated_organization = Organization.last

        expect(response).to be_successful
        expect(updated_organization.name).to eq("new_name")
        expect(updated_organization.street_address).to eq("new_street_address")
        expect(updated_organization.city).to eq("new_city")
        expect(updated_organization.state).to eq("new_state")
        expect(updated_organization.zip_code).to eq("new_zip_code")
        expect(updated_organization.email).to eq("new_email")
        expect(updated_organization.phone_number).to eq("new_phone_number")
        expect(updated_organization.website).to eq("new_website")
      end
    end

    context "when unsuccessful" do
      it "sends a 404 Not Found status when organization id not found" do
        patch api_v1_organization_path(0)

        expect(response.status).to eq(404)

        parsed_error = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error.keys).to match([:message, :errors])
        expect(parsed_error[:message]).to eq("your query could not be completed")
        expect(parsed_error[:errors].first[:status]).to eq("404")
        expect(parsed_error[:errors].first[:title]).to eq("Couldn't find Organization with 'id'=0")
      end

      it "sends a 400 status when no params are passed" do
        patch api_v1_organization_path(@organization)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body.keys).to match([:message, :errors])
        expect(response_body[:message]).to eq("your query could not be completed")
        expect(response_body[:errors].first[:status]).to eq("400")
        expect(response_body[:errors].first[:title]).to eq("param is missing or the value is empty: organization")
      end
    end
  end
end