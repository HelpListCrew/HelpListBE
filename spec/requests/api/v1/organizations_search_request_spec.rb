require "rails_helper"

RSpec.describe "Organization Search Request" do
  before do
    @library = create(:organization, name: "Library", street_address: "201 Peterson St.", city: "Fort Collins", state: "CO", zip_code: "80524" )
    @dia = create(:organization, name: "Airport", street_address: "8500 Peña Blvd", city: "Denver", state: "CO", zip_code: "80249")
    @hospital = create(:organization, name: "Hospital", street_address: "1024 S. Lemay Ave.", city: "Fort Collins", state: "CO", zip_code: "80524")
    @cityhall = create(:organization, name: "City Hall", street_address: "300 Laporte Ave", city: "Fort Collins", state: "CO", zip_code: "80521")
    @zoo = create(:organization, name: "Denver Zoo", street_address: "2300 Steele St", city: "Denver", state: "CO", zip_code: "80205")
    @averyhouse = "200 W Oak St, Fort Collins, CO 80521"

    @keys = [
      :name,
      :street_address,
      :city,
      :state,
      :zip_code,
      :email,
      :phone_number,
      :website
    ]
  end

  context "when successful" do
    it "returns all orgs within the radius of the given address, order of closest proximity" do
      get "/api/v1/organizations/find_all?address=#{@averyhouse}&miles=50"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(parsed[:data].size).to eq(3)
      expect(parsed[:data]).to be_an(Array)
      expect(parsed[:data][0][:type]).to eq("organization")
      expect(parsed[:data][0][:id]).to eq(@cityhall.id.to_s)
      expect(parsed[:data][0][:attributes].keys).to eq(@keys)
      expect(parsed[:data][0][:attributes][:name]).to eq(@cityhall.name)
      expect(parsed[:data][0][:attributes][:street_address]).to eq(@cityhall.street_address)
      expect(parsed[:data][0][:attributes][:city]).to eq(@cityhall.city)
      expect(parsed[:data][0][:attributes][:state]).to eq(@cityhall.state)
      expect(parsed[:data][0][:attributes][:zip_code]).to eq(@cityhall.zip_code)
      expect(parsed[:data][0][:attributes][:email]).to eq(@cityhall.email)
      expect(parsed[:data][0][:attributes][:phone_number]).to eq(@cityhall.phone_number)
      expect(parsed[:data][0][:attributes][:website]).to eq(@cityhall.website)
    end
  end

  context "when unsuccessful" do
    describe "returns a 200 status"do
      it "if no match found" do
        shedd = "1200 S DuSable Lk Shr Dr, Chicago, IL 60605"
        get "/api/v1/organizations/find_all?address=#{shedd}&miles=20"
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(parsed).to be_a(Hash)
        expect(parsed.keys).to eq([:data])
        expect(parsed[:data]).to eq({})
      end
    end

    describe "returns a 400 error" do
      it "if no parameters given" do
        get "/api/v1/organizations/find_all?address=&miles="
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)
			  expect(parsed[:errors].first[:title]).to eq("ActionController::BadRequest")
      end
    end
  end
end