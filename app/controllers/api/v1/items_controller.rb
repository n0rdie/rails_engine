class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def update
    item = Item.find(params[:id])
    if item
      item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: { message: "Item update failed" }
    end
  end

  private 

  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id)
  end

end