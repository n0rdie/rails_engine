require "rails_helper"

RSpec.describe "Api::V1::Items", type: :request do
  describe "GET /api/v1/items" do
    before do
          create_list(:item, 3)
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

      patch api_v1_item_path(item_update)

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
end