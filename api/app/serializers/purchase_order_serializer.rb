class PurchaseOrderSerializer < ActiveModel::Serializer
  attributes :id
  attributes :supplier_name, :supplier_id
  has_many :items, serializer: PurchaseOrderLineItemSerializer

  def supplier_name
    object.vendor_name
  end

  def supplier_id
    object.vendor_id
  end

  def items
    object.line_items
  end
end
