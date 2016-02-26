class Sku::CreateByPid
  def create(options = {})
    options.slice!(:product_id, :element_id)
    product = Product.find(options[:product_id].to_i)
    element = Element.find(options[:element_id].to_i)
    last_sku = product.skus.order(:created_at).last
    new_sku = copy_sku(last_sku)
    new_sku[:sku] = "#{product.id}-#{element.name}"
    Sku.create(new_sku)
  end

  private

  def copy_sku(sku)
    sku.as_json.symbolize_keys.except(
      :id,
      :sku,
      :created_at,
      :updated_at,
      :barcode,
      :size,
      :element_id,
      :manufacturer_size
    )
  end
end
