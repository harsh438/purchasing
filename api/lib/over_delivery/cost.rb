class OverDelivery::Cost
  def initialize(line_item, skus)
    @line_item = line_item
    @skus = skus
  end

  def process
    return 0 unless skus && line_item
    [
      line_item.orderTool_SupplierListPrice,
      line_item.cost,
      sku_cost,
      product.try(:pCost)
    ].compact.reject(&:zero?).first
  end

  private

  attr_reader :line_item, :skus

  def sku_cost
    skus.order('id DESC').first.cost_price
  end

  def product
    Product.where(pid: skus.first.product_id).first
  end
end
