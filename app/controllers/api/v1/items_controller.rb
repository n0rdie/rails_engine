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
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end
  
  def update
    result = ItemUpdater.update(params[:id], item_params)
    render result
  end

  def delete
    ItemDestroyer.destroy(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id)
  end
end
