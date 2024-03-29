class Api::V1::MerchantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def find_all
    facade = MerchantSearchFacade.new(params[:name])
    merchants = facade.search_result
    
    render json: MerchantSerializer.new(merchants)
  end
  
  
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  #private

  #def not_found_response(exception)
  #  render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
  #  .serialize_json, status: :not_found
  #end

end
