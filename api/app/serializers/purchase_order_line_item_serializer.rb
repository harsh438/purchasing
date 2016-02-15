class PurchaseOrderLineItemSerializer < ActiveModel::Serializer
  attributes :sku
  attributes :quantity
  attributes :line_id
  attributes :cost_price

  def sku
    object.product_sku
  end

  def line_id
    object.id
  end

  def cost_price
    object.cost
  end
end
