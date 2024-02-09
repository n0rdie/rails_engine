class Api::V1::Merchants::ItemsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

    def index
        merchant = Merchant.find(params[:id])
        render json: ItemSerializer.new(merchant.items)
    end

    private

    def not_found_response(exception)
        render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
        .serialize_json, status: :not_found
    end
end