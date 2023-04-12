require "rails_helper"

RSpec.describe "User Request" do
  describe "User Create" do
    it "creates a new user" do
      user_params = ({
                      email: "abc@123.com",
                      password: "password123"
                    })

      headers = { "CONTENT_TYPE" => "application/json" }

      post api_v1_users_path, headers: headers, params: JSON.generate( user: user_params )
      created_user = User.last

      expect(response).to be_successful

      expect(created_user.email).to eq("abc@123.com")
      expect(created_user.user_type).to eq("donor")
    end
  end
end