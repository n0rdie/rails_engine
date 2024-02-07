class Api::V1::ItemsController < ApplicationController
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

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
