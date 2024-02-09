class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create(item_params)
    if item.save
      render json: ItemSerializer.new(item)#, status: 201
    else
      render json: ErrorSerializer.new(ErrorMessage.new("Save failed", 404))
      .serialize_json, status: :not_found
    end
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

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: :not_found
  end
end
