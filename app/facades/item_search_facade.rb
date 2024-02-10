class ItemSearchFacade
  def initialize(name = nil, min = nil, max = nil)
    @name = name
    @min = min
    @max = max
  end

  def search_result
    return find_name if @name
    return find_min_max if @min && @max
    return find_min if @min
    return find_max if @max
  end

  def find_name
    if @min || @max
      raise ActionController::BadRequest.new("Can't send both a name and price in the request")
    else
      item = Item.where("name ILIKE ?", "%#{@name}%").first
      raise ActiveRecord::RecordNotFound.new("Couldn't find an item with the name #{@name}") unless item
      item
    end
  end

  def find_min_max
      item = Item.where("unit_price >= #{@min} AND unit_price <= #{@max}")
          .order("name").first
      raise ActiveRecord::RecordNotFound.new("Couldn't find an item greater than or equal to #{@min} and less than or equal to #{@max}") unless item
    item
  end

  def find_min
    if @min.to_f < 0.0
      raise ActionController::BadRequest.new("Min price must be greater than or equal to zero")
    else
      item = Item.where("unit_price >= ?", @min).order(:name).first
      raise ActiveRecord::RecordNotFound.new("Couldn't find an item with a unit price greater than or equal to #{@min}") unless item
      item
    end
  end

  def find_max
    if @max.to_f >= 0
      item = Item.where("unit_price <= ?", @max).order(:name).first
      raise ActiveRecord::RecordNotFound.new("Couldn't find an item less than or equal to #{@max}") unless item
      item
    else
      raise ActionController::BadRequest.new("Max price must be greater than or equal to zero") unless item
    end
  end
end