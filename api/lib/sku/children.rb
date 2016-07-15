class Children
  def initialize(sku)
    @sku = sku
    @skus = Sku.where(product_id: sku.product_id)
  end

  def as_json
    skus.map{ | sku | get_child(sku) }
  end

  private

  def get_child(sku)
    {
      sku: sku_number(sku),
      price: price(sku),
      cost_price: cost_price(sku),
      barcode: barcode(sku),
      legacy_brand_size: legacy_brand_size(sku),
      options: {
        size: surfdome_size(sku)
      }
    }
  end

  def sku_number(sku)
   sku.sku
  end

  def barcode(sku)
   sku.barcodes.map(&:barcode)
  end

  def price(sku)
    sku.price
  end

  def cost_price(sku)
   sku.cost_price
  end

  def legacy_brand_size(sku)
   sku.manufacturer_size
  end

  def surfdome_size(sku)
    sku.size
  end

  attr_reader :sku, :skus
end
