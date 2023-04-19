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
			expect(parsed[:data][0][:attributes][:username]).to eq(@user.username)
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
				expect(parsed[:data][:attributes].size).to eq(3)
				expect(parsed[:data][:attributes][:email]).to eq(@user.email)
				expect(parsed[:data][:attributes][:user_type]).to eq("donor")
				expect(parsed[:data][:attributes][:username]).to eq(@user.username)
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
                      password: "password123",
                      username: "pixelated_tiger"
                    })

      headers = { "CONTENT_TYPE" => "application/json" }

      post api_v1_users_path, headers: headers, params: JSON.generate( user: user_params )

      created_user = User.last

      expect(response).to be_successful

      expect(created_user.email).to eq("abc@123.com")
      expect(created_user.user_type).to eq("donor")
      expect(created_user.username).to eq("pixelated_tiger")
    end

    it "creates a user without the presence of a username" do
      user_params = ({
                      email: "abc@123.com",
                      password: "password123",
                    })

      headers = { "CONTENT_TYPE" => "application/json" }

      post api_v1_users_path, headers: headers, params: JSON.generate( user: user_params )

      created_user = User.last

      expect(response).to be_successful

      expect(created_user.email).to eq("abc@123.com")
      expect(created_user.user_type).to eq("donor")
      expect(created_user.username).to eq(nil)
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
				expect(error[:status]).to eq("400")

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
      @previous_username = @user.username
			@user_params = { 
											email: "Hello@123.com",
											password: @previous_pass,
                      username: "Dr. Henry Killinger"
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
				expect(parsed[:data][:attributes][:username]).to eq(updated_user.username)
				expect(parsed[:data][:attributes][:email]).to_not eq(@previous_email)
				expect(parsed[:data][:attributes][:username]).to_not eq(@previous_username)
			end
		end

		context "when unsuccessful" do
			it "returns a 400 error if invalid properties" do
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
					expect(error[:status]).to eq("400")
					expect(error[:title]).to be_a String
					expect(error[:title]).to eq("Email is invalid")
				end				
			end
		end
	end

  describe "Log in a User" do
    before :each do 
      @user = create(:user)
    end

    it "authenticates a user when given vaild parameters" do 
      user_params = ({
            email: @user.email,
            password: @user.password
          })

      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/login", headers: headers, params: JSON.generate( user: user_params )
      
			response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(response_body[:data]).to be_a(Hash)
      expect(response_body[:data].keys).to eq([:id, :type, :attributes])
      expect(response_body[:data][:id]).to eq(@user.id.to_s)
      expect(response_body[:data][:type]).to eq("user")
      expect(response_body[:data][:attributes].size).to eq(3)
      expect(response_body[:data][:attributes][:email]).to eq(@user.email)
      expect(response_body[:data][:attributes][:user_type]).to eq("donor")
      expect(response_body[:data][:attributes][:username]).to eq(@user.username)
    end

    it "does not autheticate a user with no creditentials" do
      user_params = ({
            email: "",
            password: ""
          })
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/login", headers: headers, params: JSON.generate( user: user_params )
      
			response_body = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to_not be_successful

      expect(response_body).to have_key(:message)
      expect(response_body).to have_key(:errors)
      expect(response_body[:message]).to eq("your query could not be completed")

      response_body[:errors].each do |error|
        expect(error[:status]).to eq(401)
        expect(error[:title]).to eq("Invalid credentials")
      end
    end

    it "authenticates a user with google oauth uid" do
      user_params = ({
            email: @user.email,
            uid: @user.uid
          })

      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/login", headers: headers, params: JSON.generate( user: user_params )
      
			response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(response_body[:data]).to be_a(Hash)
      expect(response_body[:data].keys).to eq([:id, :type, :attributes])
      expect(response_body[:data][:id]).to eq(@user.id.to_s)
      expect(response_body[:data][:type]).to eq("user")
      expect(response_body[:data][:attributes].size).to eq(3)
      expect(response_body[:data][:attributes][:email]).to eq(@user.email)
      expect(response_body[:data][:attributes][:user_type]).to eq("donor")
      expect(response_body[:data][:attributes][:username]).to eq(@user.username)
    end
  end

  describe "Destroy User" do
    context "when context" do
      it "can destroy a user" do
        user = create(:user)

        expect(User.count).to eq(1)

        delete "/api/v1/users/#{user.id}"

        expect(response).to be_successful
        expect(response.status).to eq(204)
        expect(User.count).to eq(0)
        expect{User.find(user.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroys associated wishlist items when recipient is deleted" do 
        recipient = create(:user, user_type: "recipient")
        recipient_item = create(:wishlist_item, recipient: recipient)
      
        delete "/api/v1/users/#{recipient.id}"

        expect(response).to be_successful
        expect(WishlistItem.count).to eq(0)
        expect{WishlistItem.find(recipient_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when unsuccessful" do
      it "sends raises an error when a user does not exist" do
         user = create(:user)

        expect(User.count).to eq(1)

        delete "/api/v1/users/thisisnotauserid"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect(User.count).to eq(1)
      end
    end
  end
end