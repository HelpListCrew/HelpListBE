require "rails_helper"

RSpec.describe "User Search Request" do
  before do
    @user1 = create(:user, email: "helloyou@elsewhere.com", username: "hello_dolly", user_type: 1)
    @user2 = create(:user, email: "hellothere@somewhere.net", username: "electric_emerald", user_type: 1)
    @user3 = create(:user, email: "otherhello@everywhere.org", username: "hola_bonita", user_type: 1)
    @user4 = create(:user, email: "goodbye@nowhere.edu", username: "Helloo_lovely", user_type: 1)
    @user5 = create(:user, email: "helloitsme@there.com", username: "ethereal_cryptid", user_type: 0)
  end

	context "when successful" do
    it "returns all recipients that match a case-insensitive search, A-Z" do
      get "/api/v1/users/find_all?username=hELlo"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(parsed[:data].size).to eq(2)
      expect(parsed[:data]).to be_an(Array)
      expect(parsed[:data][0][:type]).to eq("user")
      expect(parsed[:data][0][:attributes].keys).to eq([:email, :user_type, :username])
      expect(parsed[:data][0][:attributes][:email]).to eq(@user4.email)
      expect(parsed[:data][0][:attributes][:username]).to eq(@user4.username)
      expect(parsed[:data].sample[:attributes][:user_type]).to eq("recipient")
    end
  end

  context "when unsuccessful" do
    it "returns a 200 status if no match found" do
      get "/api/v1/users/find_all?username=nIcE"
      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(parsed).to be_a(Hash)
      expect(parsed.keys).to eq([:data])
      expect(parsed[:data]).to eq({})
    end

    it "returns a 400 error if no username parameters given" do
      get "/api/v1/users/find_all?username="
      parsed = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(400)
			expect(parsed[:errors].first[:title]).to eq("ActionController::BadRequest")
    end
  end
end