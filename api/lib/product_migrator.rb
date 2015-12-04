class ProductMigrator
  def migrate
    Product.find_in_batches.with_index do |group, batch|
      group.each { |product| migrate_single(product) }
    end
  end

  def migrate_single(product)
    @product = product
    Sku.create!(sku_attrs)
  end

  private

  def product
    @product
  end

  def sku_attrs
    { manufacturer_sku: product.name,
      product_id: product.id,
      product_name: product.language_product.name }
  end
end
