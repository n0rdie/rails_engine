require "rails_helper"

RSpec.describe "Api::V1::Merchants", type: :request do
  describe "GET /api/v1/merchants" do
    before do
      create_list(:merchant, 3)
    end

    it "returns all merchants" do
      get api_v1_merchants_path

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"].size).to eq(3)
      expect(json_response["data"].size).not_to eq(nil)
      expect(json_response["data"].first["attributes"]).to include("id", "name")
      expect(json_response["data"].last["attributes"]).to include("id", "name")
    end
  end
end