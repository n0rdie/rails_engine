class Api::V1::MerchantsController < ApplicationController

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

end
