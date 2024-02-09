class MerchantSearchFacade
  def initialize(name = nil)
    @name = name
  end

  def search_result
    return find_all_name if @name
  end

  def find_all_name
    merchants = Merchant.where("name ILIKE ?", "%#{@name}%")
    raise ActiveRecord::RecordNotFound.new("Couldn't find any merchants matching #{@name}") unless merchants.present?
    merchants
  end
end