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
      expect(json_response["data"].first["attributes"]).to include("id", "name", "description", "unit_price", "merchant_id")
      expect(json_response["data"].last["attributes"]).to include("id", "name", "description", "unit_price", "merchant_id")
    end
  end
end