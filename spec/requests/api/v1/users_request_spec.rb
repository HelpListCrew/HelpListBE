require "rails_helper"

RSpec.describe "User Request" do
	describe "Users Get" do
		before do
			create_list(:user, 3)
			@user = User.first
		end

		it "gets all users" do
			get api_v1_users_path
			parsed = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful
			expect(parsed[:data].size).to eq(3)
			expect(parsed[:data]).to be_an(Array)
			expect(parsed[:data][0].keys).to eq([:id, :type, :attributes])
			expect(parsed[:data][0][:id]).to eq(@user.id.to_s)
			expect(parsed[:data][0][:type]).to eq("user")
			expect(parsed[:data][0][:attributes][:email]).to eq(@user.email)
			expect(parsed[:data][0][:attributes][:user_type]).to eq("donor")
		end
	end

	describe "User Get" do
		before do
			@user = create(:user)
		end
		
		context "when successful" do
			it "gets one user" do
				get api_v1_user_path(@user)

				parsed = JSON.parse(response.body, symbolize_names: true)
				expect(response).to be_successful
				expect(parsed[:data]).to be_a(Hash)
				expect(parsed[:data].keys).to eq([:id, :type, :attributes])
				expect(parsed[:data][:id]).to eq(@user.id.to_s)
				expect(parsed[:data][:type]).to eq("user")
				expect(parsed[:data][:attributes].size).to eq(2)
				expect(parsed[:data][:attributes][:email]).to eq(@user.email)
				expect(parsed[:data][:attributes][:user_type]).to eq("donor")
			end
		end

		context "when unsuccessful" do
			it "returns a 404 error" do
				get api_v1_user_path("9938794823784")
				parsed = JSON.parse(response.body, symbolize_names: true)

				expect(response).to have_http_status(404)
				expect(parsed[:errors].first[:title]).to eq("Couldn't find User with 'id'=9938794823784")
			end
		end
	end

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

		it "does not allow user to be created if invalid properties" do
			user_params = ({
				email: "abc",
				password: "password123"
			})

			headers = { "CONTENT_TYPE" => "application/json" }

			post api_v1_users_path, headers: headers, params: JSON.generate( user: user_params )

			expect(response).to have_http_status(404)

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response_body.keys).to match([:message, :errors])

			expect(response_body[:message]).to be_a String
			expect(response_body[:errors]).to be_an Array

			response_body[:errors].each do |error|
				expect(error).to be_a Hash
				expect(error.keys).to match([:status, :title])

				expect(error[:status]).to be_a String
				expect(error[:status]).to eq("404")

				expect(error[:title]).to be_a String
				expect(error[:title]).to eq("Email is invalid")
			end
		end
  end

	describe "User Update" do
		before do
			@user = create(:user)
			@previous_email = User.find_by(id: @user.id).email
			@previous_pass = @user.password
			@user_params = { 
											email: "Hello@123.com",
											password: @previous_pass
										}
			@headers = { "CONTENT_TYPE" => "application/json" }
		end

		context "when successful" do
			it "it updates an existing User" do
				patch api_v1_user_path(@user.id), headers: @headers, params: JSON.generate({user: @user_params})
				parsed = JSON.parse(response.body, symbolize_names: true)
				updated_user = User.find_by(id: @user.id)
				expect(response).to be_successful
				expect(parsed[:data]).to be_a(Hash)
				expect(parsed[:data].keys).to eq([:id, :type, :attributes])
				expect(parsed[:data][:attributes][:email]).to eq(updated_user.email)
				expect(parsed[:data][:attributes][:email]).to_not eq(@previous_email)
			end
		end

		context "when unsuccessful" do
			it "returns a 404 error if invalid properties" do
				@user_params[:email] = "abc"
				patch api_v1_user_path(@user.id), headers: @headers, params: JSON.generate({user: @user_params})
				response_body = JSON.parse(response.body, symbolize_names: true)

				expect(response_body.keys).to match([:message, :errors])
				expect(response_body[:message]).to be_a String
				expect(response_body[:errors]).to be_an Array
	
				response_body[:errors].each do |error|
					expect(error).to be_a Hash
					expect(error.keys).to match([:status, :title])
					expect(error[:status]).to be_a String
					expect(error[:status]).to eq("404")
					expect(error[:title]).to be_a String
					expect(error[:title]).to eq("Email is invalid")
				end				
			end
		end
	end
end