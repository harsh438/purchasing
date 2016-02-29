class Sku::CreateByPid
  def create(options = {})
    options.slice!(:product_id, :element_id)
    product = Product.find(options[:product_id].to_i)
    element = Element.find(options[:element_id].to_i)
    last_sku = product.skus.order(:created_at).last
    sku_attrs = copy_sku_attributes(last_sku, product, element)
    Sku::Generator.new.generate_new_sku(sku_attrs)
  end

  private
  def copy_sku_attributes(sku, product, element)
    sku_attrs = sku.as_json.symbolize_keys.except(:barcode, :manufacturer_size)
    sku_attrs[:internal_sku] = "#{product.id}-#{element.name}"
    sku_attrs[:size] = element.name
    sku_attrs
  end
end
