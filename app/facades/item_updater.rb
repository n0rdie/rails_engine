class ItemUpdater
  def self.update(item_id, item_params)
    item = Item.find_by(id: item_id)

    if item.nil?
      return { json: { error: "Item not found" }, status: :not_found }
    end

    if item_params.key?(:merchant_id) && !Merchant.exists?(item_params[:merchant_id])
      return { json: { error: "Merchant not found" }, status: :not_found }
    end

    if item.update(item_params)
      return { json: ItemSerializer.new(item), status: :ok }
    else
      return { json: { message: "Item update failed" }, status: :unprocessable_entity }
    end
  end
end