class Order::SkuNotFound < RuntimeError
  attr_reader :sku, :season

  def initialize(sku, season=nil)
    @sku = sku
    @season = season
  end
end
