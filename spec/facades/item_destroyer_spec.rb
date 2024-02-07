require "rails_helper"

RSpec.describe ItemDestroyer do
  describe ".destroy" do
    let!(:merchant) { create(:merchant) }
    let!(:customer) { create(:customer) }
    let!(:item) { create(:item, merchant: merchant) }
    let!(:invoice) { create(:invoice, customer: customer, merchant: merchant) }
    let!(:invoice_item) { create(:invoice_item, item: item, invoice: invoice) }

    it "destroys the item and associated data correctly" do
      expect { ItemDestroyer.destroy(item.id) }
        .to change { Item.count }.by(-1)
        .and change { InvoiceItem.count }.by(-1)
        .and change { Invoice.count }.by(-1)
    end
  end
end