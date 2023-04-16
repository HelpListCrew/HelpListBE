require "rails_helper"

RSpec.describe "Wishlist Items Request" do
  describe "Show Wishlist Item" do
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

  describe "Index Wishlist Items" do
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
        expect(created_wishlist_item.api_item_id).to eq("1")
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

      it "returns 400 error when no params are passed" do
        recipient = create(:user, user_type: 1)

        post api_v1_wishlist_items_path

        response_body = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to_not be_successful

        expect(response_body.keys).to match([:message, :errors])
        expect(response_body[:message]).to eq("your query could not be completed")
        expect(response_body[:errors].first[:status]).to eq("400")
        expect(response_body[:errors].first[:title]).to eq("param is missing or the value is empty: wishlist_item")
      end
    end
  end

  describe "Update Wishlist Item" do
    before(:each) do
      @wishlist_item = create(:wishlist_item)
    end

    context "when successful" do
      it "updates a wishlist item attribute" do
        wishlist_item_params = ({
                                purchased: true,
                                received: true
                               })

        headers = { "CONTENT_TYPE" => "application/json" }

        patch api_v1_wishlist_item_path(@wishlist_item), headers: headers, params: JSON.generate(wishlist_item: wishlist_item_params)

        updated_wishlist_item = WishlistItem.last

        expect(response).to be_successful
        expect(updated_wishlist_item.purchased).to eq(true)
        expect(updated_wishlist_item.received).to eq(true)
      end
    end

    context "when unsuccessful" do
      it "sends a 404 Not Found status when item id not found" do
        patch api_v1_wishlist_item_path(0)

        expect(response.status).to eq(404)

        parsed_error = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error.keys).to match([:message, :errors])
        expect(parsed_error[:message]).to eq("your query could not be completed")
        expect(parsed_error[:errors].first[:status]).to eq("404")
        expect(parsed_error[:errors].first[:title]).to eq("Couldn't find WishlistItem with 'id'=0")
      end

      it "sends a 400 status when invalid parameters" do
        wishlist_item_params = ({
                                api_item_id: "one"
                               })

        headers = { "CONTENT_TYPE" => "application/json" }

        patch api_v1_wishlist_item_path(@wishlist_item), headers: headers, params: JSON.generate(wishlist_item: wishlist_item_params)

        parsed_error = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(parsed_error[:message]).to eq("your query could not be completed")
        expect(parsed_error[:errors].first[:status]).to eq("400")
        expect(parsed_error[:errors].first[:title]).to eq("Validation failed: Api item is not a number")
      end

      it "sends a 400 status when no params are passed" do
        patch api_v1_wishlist_item_path(@wishlist_item)

        parsed_error = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(parsed_error[:message]).to eq("your query could not be completed")
        expect(parsed_error[:errors].first[:status]).to eq("400")
        expect(parsed_error[:errors].first[:title]).to eq("param is missing or the value is empty: wishlist_item")
      end
    end
  end

  describe "Destroy Wishlist Item" do
    context "when successful" do
      it "destroys a wishlist item" do
        wishlist_item = create(:wishlist_item)

        expect(WishlistItem.count).to eq(1)

        delete api_v1_wishlist_item_path(wishlist_item)

        expect(response).to be_successful
        expect(response.status).to eq(204)
        expect(WishlistItem.count).to eq(0)
        expect{WishlistItem.find(wishlist_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroys associated donor items when wishlist item deleted" do
        wishlist_item = create(:wishlist_item)
        donor_item = create(:donor_item, wishlist_item: wishlist_item)

        delete api_v1_wishlist_item_path(wishlist_item)

        expect(response).to be_successful
        expect(DonorItem.count).to eq(0)
        expect{DonorItem.find(donor_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when unsuccessful" do
      it "sends a 404 Not Found status when item id not found" do
        delete api_v1_wishlist_item_path(0)

        parsed_error = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(parsed_error[:message]).to eq("your query could not be completed")
        expect(parsed_error[:errors].count).to eq(1)
        expect(parsed_error[:errors].first[:status]).to eq("404")
        expect(parsed_error[:errors].first[:title]).to eq("Couldn't find WishlistItem with 'id'=0")
      end
    end
  end
end