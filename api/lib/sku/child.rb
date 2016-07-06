class Child
  def initialize(sku)
    @sku = sku
  end

  def as_json
    {
      sku: sku_number,
      price: price,
      cost_price: cost_price,
      barcode: barcode,
      legacy_brand_size: legacy_brand_size,
      options: {
        size: surfdome_size
      }
    }
  end

  private

  def sku_number
    @sku_number ||= sku.sku
  end

  def barcode
   @barcode ||= sku.barcodes.map(&:barcode)
  end

  def price
    @price ||= sku.price
  end

  def cost_price
    @cost_price ||= sku.cost_price
  end

  def legacy_brand_size
    @legacy_brand_size ||= sku.manufacturer_size
  end

  def surfdome_size
    @surfdome_size ||= sku.size
  end

  attr_reader :sku
end
