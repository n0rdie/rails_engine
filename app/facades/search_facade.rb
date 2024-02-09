class SearchFacade
  def initialize(search_params)
    @search_params = search_params
  end

  def find_item
    if @search_params[:name]
      Item.find_name(@search_params[:name])
    elsif @search_params[:min_price] && @search_params[:max_price]
      Item.where("unit_price >= ?", @search_params[:min_price])
          .where("unit_price <= ?", @search_params[:max_price])
          .order(:name).first
    elsif @search_params[:min_price]
      Item.where("unit_price >= ?", @search_params[:min_price])
          .order(:name).first
    elsif @search_params[:max_price]
      Item.where("unit_price <= ?", @search_params[:max_price])
          .order(:name).first
    end
  end
end