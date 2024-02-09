require "rails_helper"

RSpec.describe "Api::V1::Items::Merchant", type: :request do
    it "6. Relationship Endpoints -- Item's Merchant" do
        merchant = create(:merchant)
        new_item_data = ({
            "name": "value1",
            "description": "value2",
            "unit_price": 100.99,
            "merchant_id": merchant.id
        })
        post "/api/v1/items", headers: {"CONTENT_TYPE" => "application/json"}, params: JSON.generate(item: new_item_data)
        item = Item.last

        get "/api/v1/items/#{item.id}/merchant"
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:data][:attributes][:name]).to eq(merchant.name)
    end

    it "6. Relationship Endpoints -- Item's Merchant [SAD]" do
        get "/api/v1/items/1/merchant"
        expect(response).to_not be_successful
    end
end