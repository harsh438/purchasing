class Order::SkuNotFound < RuntimeError
  attr_reader :sku

  def initialize(sku)
    @sku = sku
  end
end
