require "rails_helper"

RSpec.describe "Api::V1::Items::Merchant", type: :request do
    it "6. Relationship Endpoints -- Item's Merchant" do
        merchant = create(:merchant)

        new_item_data_1 = ({
            "name": "item1",
            "description": "item1",
            "unit_price": 100.99,
            "merchant_id": merchant.id
        })
        post "/api/v1/items", headers: {"CONTENT_TYPE" => "application/json"}, params: JSON.generate(item: new_item_data_1)
        
        new_item_data_2 = ({
            "name": "item2",
            "description": "item2",
            "unit_price": 100.99,
            "merchant_id": merchant.id
        })
        post "/api/v1/items", headers: {"CONTENT_TYPE" => "application/json"}, params: JSON.generate(item: new_item_data_2)

        get "/api/v1/merchants/#{merchant.id}/items"
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:data].count).to eq(2)
        expect(json_response[:data][0][:attributes][:name]).to eq("item1")
        expect(json_response[:data][1][:attributes][:name]).to eq("item2")
    end
end