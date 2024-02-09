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
      expect(json_response["data"].first["attributes"]).to include("name")
      expect(json_response["data"].last["attributes"]).to include("name")
    end
  end

  describe "GET /api/v1/merchants/:id" do
    let!(:merchant) { create(:merchant) }

    it "returns specified item attributes" do
      get api_v1_merchant_path(merchant)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["id"]).to eq(merchant.id.to_s)
      expect(json_response["data"]["type"]).to eq("merchant")
      expect(json_response["data"]["attributes"]["name"]).to eq(merchant.name)
    end
  end

  describe "GET /api/v1/items/find_all" do
    before do 
      @merchant1 = create(:merchant, name: "Darlington Furniture Warehouse")
      @merchant2 = create(:merchant, name: "Arlington Race Track")
      @merchant3 = create(:merchant, name: "Huntington Bank")
      @merchant4 = create(:merchant, name: "5/3 Bank & Trust")
      @merchant5 = create(:merchant, name: "D-Town and Sons Fun Factory")
    end

    it "will do a partial name search for a merchant(s) and return any that match the pattern" do
      get "/api/v1/merchants/find_all", headers: {"CONTENT_TYPE" => "application/json"}, params: { name: "Ing" }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response["data"].count).to eq(3)
      expect(json_response["data"].first["id"].to_i).to eq(@merchant1.id)
      expect(json_response["data"].first["type"]).to eq("merchant")
      expect(json_response["data"].first["attributes"]["name"]).to eq("Darlington Furniture Warehouse")
      expect(json_response["data"].second["attributes"]["name"]).to eq("Arlington Race Track")
      expect(json_response["data"].third["attributes"]["name"]).to eq("Huntington Bank")
    end
  end

  it "will gracefully handle a search where no merchants can be found in partial name search" do 
    sad_name = "23423"
    get "/api/v1/merchants/find_all", headers: {"CONTENT-TYPE" => "application/json"}, params: { name: sad_name }
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    
    json_response = JSON.parse(response.body)
    expect(json_response["errors"]).to be_a(Array)
    expect(json_response["errors"].first["status"].to_i).to eq(404)
    expect(json_response["errors"].first["title"]).to eq("Couldn't find any merchants matching #{sad_name}")
  end
end