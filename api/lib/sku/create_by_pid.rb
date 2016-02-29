class Sku::CreateByPid
  def create(options)
    ActiveRecord::Base.transaction do
      generate_sku(options)
    end
  end

  private

  def generate_sku(options)
    product = Product.find(options.fetch(:product_id))
    element = Element.find(options.fetch(:element_id))
    last_sku = product.skus.order(:created_at).last
    sku = Sku::Generator.new.generate(copy_sku_attributes(last_sku, product, element))
    save_sku(sku, product, last_sku)
  end

  def copy_sku_attributes(sku, product, element)
    sku_attrs = sku.as_json.symbolize_keys.except(:barcode, :manufacturer_size)
    sku_attrs[:internal_sku] = "#{product.id}-#{element.name}"
    sku_attrs[:size] = element.name
    sku_attrs
  end

  def save_sku(sku, product, last_sku)
    sku.product_id = product.id
    sku.language_product_id = last_sku.language_product_id
    sku.save!
    sku
  end
end
