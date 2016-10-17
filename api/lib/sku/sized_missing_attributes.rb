class Sku::SizedMissingAttributes
  attr_reader :unsized_missing_attrs

  def initialize(unsized_missing_attrs)
    @unsized_missing_attrs = unsized_missing_attrs
  end

  def retrieve_attributes
    unsized_missing_attrs.retrieve_attributes.merge(sized_attrs)
  end

  private

  def missing_sku_id
    @missing_sku_id ||= unsized_missing_attrs.missing_sku_id
  end

  def po_line_item
    @po_line_item ||= PurchaseOrderLineItem.find_by(sku_id: missing_sku_id)
  end

  def product
    @product ||= Product.find_by(id: po_line_item.product_id)
  end

  def sized_attrs
    {
      sku: "#{product.id}-#{element_id}",
      option_id: po_line_item.option_id,
      element_id: element_id,
      manufacturer_size: po_line_item.manufacturer_size,
      size: po_line_item.product_size,
      inv_track: 'O',
      language_product_option_id: product.language_product_options.first.try(:id)
    }
  end

  def element_id
    @element_id ||= Element.find_by(name: po_line_item.product_size).id
  end
end
