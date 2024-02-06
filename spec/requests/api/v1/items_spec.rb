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
end