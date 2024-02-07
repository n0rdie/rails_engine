# I am become death, destroyer of items
class ItemDestroyer
  def self.destroy(item_id)
    item = Item.find(item_id)

    item_invoices = item.invoices.to_a

    item.invoice_items.destroy_all

    item.destroy
    
    item_invoices.each do |invoice|
      invoice.reload
      if invoice.items.empty?
        invoice.destroy
      end
    end
  end
end