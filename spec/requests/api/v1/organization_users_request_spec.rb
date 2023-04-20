require "rails_helper"

RSpec.describe "Find Org User Request" do
  before do
    @org = create(:organization, name: "Library", street_address: "201 Peterson St.", city: "Fort Collins", state: "CO", zip_code: "80524" )
    @org2 = create(:organization, name: "Airport", street_address: "8500 Peña Blvd", city: "Denver", state: "CO", zip_code: "80249")

    @user1 = create(:user, email: "helloyou@elsewhere.com", username: "hello_dolly", user_type: 1)
    @user2 = create(:user, email: "hellothere@somewhere.net", username: "electric_emerald", user_type: 1)
    @user3 = create(:user, email: "otherhello@everywhere.org", username: "hola_bonita", user_type: 1)
    @user4 = create(:user, email: "goodbye@nowhere.edu", username: "Helloo_lovely", user_type: 1)

    @org_us1 = create(:organization_user, organization: @org, user: @user1)
    @org_us2 = create(:organization_user, organization: @org, user: @user2)
    @org_us3 = create(:organization_user, organization: @org, user: @user3)

    @org2_us4 = create(:organization_user, organization: @org2, user: @user4)
  end

  context "when successful" do
    it "returns all org recipients that match a case-insensitive search, A-Z" do
      get "/api/v1/organizations/#{@org.id}/find_all?username=hELlo"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(parsed[:data].size).to eq(3)
      expect(parsed[:data]).to be_a(Array)
      expect(parsed[:data][0].keys).to eq([:id, :type, :attributes])
      expect(parsed[:data][0][:id]).to eq(@user1.id.to_s)
      expect(parsed[:data][0][:type]).to eq("user")
      expect(parsed[:data][0][:attributes].size).to eq(3)
      expect(parsed[:data][0][:attributes][:email]).to eq(@user1.email)
      expect(parsed[:data][0][:attributes][:user_type]).to eq("recipient")
      expect(parsed[:data][0][:attributes][:username]).to eq(@user1.username)
    end
  end
end