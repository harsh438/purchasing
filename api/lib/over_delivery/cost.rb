class OverDelivery::Cost
  def initialize(line_item, skus)
    @line_item = line_item
    @skus = skus
    @cost_array = []
  end

  def process
    build_array
    cost_array.compact.reject(&:zero?).first
  end

  def build_array
    cost_array << line_item.orderTool_SupplierListPrice if line_item.present?
    cost_array << line_item.cost if line_item.present?
    cost_array << sku_cost if skus.present?
    cost_array << product.try(:pCost) if skus.present?
  end

  private

  attr_reader :line_item, :skus, :cost_array

  def sku_cost
    skus.order('id DESC').first.cost_price
  end

  def product
    Product.where(pid: skus.first.product_id).first
  end
end
