class SearchFacade
  def initialize(name = nil, min = nil, max = nil)
    @name = name
    @min = min
    @max = max
  end

  def search_result
    return find_name(@name).first if @name
    return find_min_max(@min, @max) if @min && @max
    return find_min(@min) if @min
    return find_max(@max) if @max
  end

  def find_name(item_name)
    Item.where("name ILIKE ?", "%#{item_name}%")
  end

  def find_min_max(min, max)
    Item.where("unit_price >= #{min} AND unit_price <= #{max}")
        .order("name").first
  end

  def find_min(min)
    Item.where("unit_price >= ?", min).order(:name).first
  end

  def find_max(max)
    Item.where("unit_price <= ?", max).order(:name).first
  end
end