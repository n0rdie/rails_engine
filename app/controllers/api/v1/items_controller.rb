class Api::V1::ItemsController < ApplicationController
  def find
    item = SearchFacade.new(params).find_item
    render json: ItemSerializer.new(item)
  end

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params))
  end
  
  def update
    # TODO On branch US-4... create sad paths for unfound items (e.g. id = 1234545234234234 does not exist)
    item = Item.find(params[:id])
    if item
      item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: { message: "Item update failed" }
    end
  end

  def destroy
    ItemDestroyer.destroy(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id)
  end
end
