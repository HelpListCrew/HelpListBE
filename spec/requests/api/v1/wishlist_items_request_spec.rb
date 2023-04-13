require "rails_helper"

RSpec.describe "Wishlist Items Request" do
  describe "Get Wishlist Item" do
    context "when successful" do
      it "retrieves a specific wishlist item" do
        wishlist_item = create(:wishlist_item)

        get api_v1_wishlist_item_path(wishlist_item)

        parsed_wishlist_item = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_wishlist_item[:data]).to be_a(Hash)
				expect(parsed_wishlist_item[:data].keys).to eq([:id, :type, :attributes])
				expect(parsed_wishlist_item[:data][:id]).to eq(wishlist_item.id.to_s)
				expect(parsed_wishlist_item[:data][:type]).to eq("wishlist_item")
				expect(parsed_wishlist_item[:data][:attributes].size).to eq(3)
				expect(parsed_wishlist_item[:data][:attributes][:api_item_id]).to eq(wishlist_item.api_item_id)
				expect(parsed_wishlist_item[:data][:attributes][:purchased]).to eq(false)
				expect(parsed_wishlist_item[:data][:attributes][:received]).to eq(false)
      end
    end

    context "when unsuccessful" do
      it "sends a 404 status error when item id not found" do
        get api_v1_wishlist_item_path(0)

        parsed_wishlist_item = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(parsed_wishlist_item[:message]).to eq("your query could not be completed")
        expect(parsed_wishlist_item[:errors].count).to eq(1)
        expect(parsed_wishlist_item[:errors].first[:status]).to eq("404")
        expect(parsed_wishlist_item[:errors].first[:title]).to eq("Couldn't find WishlistItem with 'id'=0")
      end
    end
  end

  describe "Get All Wishlist Items" do
    context "when successful" do
      it "retrieves all wishlist items" do
        create_list(:wishlist_item, 3)

        get api_v1_wishlist_items_path
        parsed_wishlist_items = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_wishlist_items[:data]).to be_an(Array)
        expect(parsed_wishlist_items[:data].count).to eq(3)

        parsed_wishlist_items[:data].each do |parsed_wishlist_item|
          expect(parsed_wishlist_item.keys).to eq([:id, :type, :attributes])
          expect(parsed_wishlist_item[:type]).to eq("wishlist_item")
          expect(parsed_wishlist_item[:attributes].size).to eq(3)
          expect(parsed_wishlist_item[:attributes][:purchased]).to eq(false)
          expect(parsed_wishlist_item[:attributes][:received]).to eq(false)
        end
      end
    end
  end

  describe "Create Wishlist Item" do
    context "when successful" do
      it "creates a new wishlist item" do
        recipient = create(:user, user_type: 1)

        wishlist_item_params = ({
                                recipient_id: recipient.id, 
                                api_item_id: 1
                               })

        headers = { "CONTENT_TYPE" => "application/json" }

        post api_v1_wishlist_items_path, headers: headers, params: JSON.generate(wishlist_item: wishlist_item_params)

        created_wishlist_item = WishlistItem.last

        expect(response).to be_successful
        expect(created_wishlist_item.api_item_id).to eq(1)
        expect(created_wishlist_item.purchased).to eq(false)
        expect(created_wishlist_item.received).to eq(false)
      end
    end

    context "when unsuccessful" do
      it "returns 400 error when missing recipient_id" do
        wishlist_item_params = ({
                                 api_item_id: 1
                               })

        headers = { "CONTENT_TYPE" => "application/json" }

        post api_v1_wishlist_items_path, headers: headers, params: JSON.generate(wishlist_item: wishlist_item_params)
        
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body.keys).to match([:message, :errors])
        expect(response_body[:message]).to eq("your query could not be completed")
        expect(response_body[:errors].first[:status]).to eq("400")
        expect(response_body[:errors].first[:title]).to eq("Recipient must exist")
      end

      it "returns 400 error when invalid data type submitted" do
        recipient = create(:user, user_type: 1)

        wishlist_item_params = ({
                                recipient_id: recipient.id, 
                                api_item_id: "one"
                               })

        headers = { "CONTENT_TYPE" => "application/json" }

        post api_v1_wishlist_items_path, headers: headers, params: JSON.generate(wishlist_item: wishlist_item_params)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body.keys).to match([:message, :errors])
        expect(response_body[:message]).to eq("your query could not be completed")
        expect(response_body[:errors].first[:status]).to eq("400")
        expect(response_body[:errors].first[:title]).to eq("Api item is not a number")
      end
    end
  end
end