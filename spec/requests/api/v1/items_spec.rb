require "rails_helper"

RSpec.describe "Api::V1::Items", type: :request do
  describe "GET /api/v1/items" do
    before do
          create_list(:item, 3)
    end

    it "3: Create an Item" do
      original_num_items = Item.all.count

      merchant = create(:merchant)
      new_item_data = ({
        "name": "value1",
        "description": "value2",
        "unit_price": 100.99,
        "merchant_id": merchant.id
      })

      post "/api/v1/items", headers: {"CONTENT_TYPE" => "application/json"}, params: JSON.generate(item: new_item_data)

      expect(response).to have_http_status(:success)
      expect(Item.all.count).to eq(original_num_items+1)
      expect(Item.last.name).to eq("value1")
      expect(Item.last.description).to eq("value2")
      expect(Item.last.unit_price).to eq(100.99)
      expect(Item.last.merchant_id).to eq(merchant.id)
    end

    it "returns all items" do
      get api_v1_items_path

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"].size).to eq(3)
      expect(json_response["data"].size).not_to eq(nil)
      expect(json_response["data"].first["attributes"]).to include("name", "description", "unit_price")
      expect(json_response["data"].last["attributes"]).to include("name", "description", "unit_price")
    end
  end

  describe "GET /api/v1/items/:id" do
    let!(:item) { create(:item) }
    it "returns specified item attributes" do
      get api_v1_item_path(item)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["id"]).to eq(item.id.to_s)
      expect(json_response["data"]["type"]).to eq("item")
      expect(json_response["data"]["attributes"]["name"]).to eq(item.name)
      expect(json_response["data"]["attributes"]["description"]).to eq(item.description)
      expect(json_response["data"]["attributes"]["unit_price"]).to eq(item.unit_price)
      expect(json_response["data"]["attributes"]["merchant_id"]).to eq(item.merchant_id)
    end
  end

  describe "PATCH /api/v1/items/:id" do 
    it "updates a specified item's attributes" do
      merchant = create(:merchant, id: 7)
      json_input = {
        "name": "value1",
        "description": "value2",
        "unit_price": 100.99,
        "merchant_id": 7
      }
      item = Item.create!(json_input)
      item_update = {id: item.id, name: "Turing School", description: "Best boot camp ever", unit_price: 22000.00}
      
      get api_v1_item_path(item)
      
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["id"]).to eq(item.id.to_s)
      expect(json_response["data"]["type"]).to eq("item")
      expect(json_response["data"]["attributes"]["name"]).to eq("value1")
      expect(json_response["data"]["attributes"]["description"]).to eq("value2")
      expect(json_response["data"]["attributes"]["unit_price"]).to eq(100.99)
      expect(json_response["data"]["attributes"]["merchant_id"]).to eq(7)

      patch "/api/v1/items/#{item.id}", headers: {"CONTENT_TYPE" => "application/json"}, params: JSON.generate(item: item_update)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["id"]).to eq(item.id.to_s)
      expect(json_response["data"]["type"]).to eq("item")
      expect(json_response["data"]["attributes"]["name"]).to eq("Turing School")
      expect(json_response["data"]["attributes"]["description"]).to eq("Best boot camp ever")
      expect(json_response["data"]["attributes"]["unit_price"]).to eq(22000.00)
      expect(json_response["data"]["attributes"]["merchant_id"]).to eq(7)
    end
  end

  describe "GET /api/v1/items/find" do
    before do
      @item_1 = create(:item, name: "Alcoa", unit_price: 19.99)
      @item_2 = create(:item, name: "Amazon", unit_price: 12.09)
      @item_3 = create(:item, name: "Apple", unit_price: 11.99)
      @item_4 = create(:item, name: "Google", unit_price: 27.32)
      @item_5 = create(:item, name: "Facebook", unit_price: 13.64)
    end

    it "searches for an item by name" do
      get "/api/v1/items/find", headers: {"CONTENT_TYPE" => "application/json"}, params: { name: "Google" }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["id"].to_i).to eq(@item_4.id)
      expect(json_response["data"]["type"]).to eq("item")
      expect(json_response["data"]["attributes"]["name"]).to eq("Google")
      expect(json_response["data"]["attributes"]["description"]).to eq(@item_4.description)
      expect(json_response["data"]["attributes"]["unit_price"]).to eq(27.32)
      expect(json_response["data"]["attributes"]["merchant_id"]).to eq(@item_4.merchant_id)
    end

    it "searches for an item by minimum price, and if more than one match criteria, it will take the item whose name is lowest (closer to 'a'), alphabetically" do
      get "/api/v1/items/find", headers: {"CONTENT_TYPE" => "application/json"}, params: { min_price: 12.00 }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["id"].to_i).to eq(@item_1.id)
      expect(json_response["data"]["type"]).to eq("item")
      expect(json_response["data"]["attributes"]["name"]).to eq("Alcoa")
      expect(json_response["data"]["attributes"]["description"]).to eq(@item_1.description)
      expect(json_response["data"]["attributes"]["unit_price"]).to eq(19.99)
      expect(json_response["data"]["attributes"]["merchant_id"]).to eq(@item_1.merchant_id)
    end

    it "searches for an item by maximum price, and if more than one match criteria, it will take the item whose name is lowest (closer to 'a'), alphabetically" do
      get "/api/v1/items/find", headers: {"CONTENT_TYPE" => "application/json"}, params: { max_price: 13.00 }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["id"].to_i).to eq(@item_2.id)
      expect(json_response["data"]["type"]).to eq("item")
      expect(json_response["data"]["attributes"]["name"]).to eq("Amazon")
      expect(json_response["data"]["attributes"]["description"]).to eq(@item_2.description)
      expect(json_response["data"]["attributes"]["unit_price"]).to eq(12.09)
      expect(json_response["data"]["attributes"]["merchant_id"]).to eq(@item_2.merchant_id)
    end

    it "searches for an item by both maximum and minimum price, and if more than one match criteria, it will take the item whose name is lowest (closer to 'a'), alphabetically" do
      get "/api/v1/items/find", headers: {"CONTENT_TYPE" => "application/json"}, params: { min_price: 20.99, max_price: 29.99 }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["id"].to_i).to eq(@item_4.id)
      expect(json_response["data"]["type"]).to eq("item")
      expect(json_response["data"]["attributes"]["name"]).to eq("Google")
      expect(json_response["data"]["attributes"]["description"]).to eq(@item_4.description)
      expect(json_response["data"]["attributes"]["unit_price"]).to eq(27.32)
      expect(json_response["data"]["attributes"]["merchant_id"]).to eq(@item_4.merchant_id)
    end

    it "returns a " do
      get "/api/v1/items/find", headers: {"CONTENT_TYPE" => "application/json"}, params: { min_price: 20.99, max_price: 29.99 }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
    end
  end
end