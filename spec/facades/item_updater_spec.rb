require "rails_helper"

RSpec.describe ItemUpdater, type: :facade do
  describe ".update" do
    let(:item) { create(:item) }
    let(:merchant) { create(:merchant) }


    it "returns an error message when the item does not exist" do
      result = ItemUpdater.update(0, { name: "Fart Spray", merchant_id: merchant.id })

      expect(result[:status]).to eq(:not_found)
      expect(result[:json][:error]).to eq("Item not found")
    end


    context "when the merchant does not exist" do
      it "returns an error message" do
        result = ItemUpdater.update(item.id, { name: "Fart Spray", merchant_id: 0 })

        expect(result[:status]).to eq(:not_found)
        expect(result[:json][:error]).to eq("Merchant not found")
      end
    end


    it "returns the updated item when the item is successfully updated" do
      result = ItemUpdater.update(item.id, { name: "Fart Spray", merchant_id: merchant.id })
      updated_item = Item.find(item.id)
    
      expect(result[:status]).to eq(:ok)
      expect(updated_item.name).to eq("Fart Spray")
    end

    it "returns an error message when the update fails" do
      result = ItemUpdater.update(item.id, { name: "", merchant_id: merchant.id })
    
      expect(result[:status]).to eq(:unprocessable_entity)
      expect(result[:json][:message]).to eq("Item update failed") 
    end
  end
end