class Parent
  def initialize(sku)
    @sku = sku
  end

  def as_json
    {
      id: id,
      sku: id,
      price: price,
      sale_price: sale_price,
      cost_price: cost_price,
      use_legacy_slug: true,
      barcode: barcode,
      active: active,
      brand: brand
    }
  end

  private

  attr_reader :sku

  def id
    sku.product_id
  end

  def price
    sku.price
  end

  def sale_price
    sku.product.pSalesPrice if sku.on_sale
  end

  def barcode
    sku.product.pUDFValue1
  end

  def cost_price
    sku.cost_price
  end

  def active
    sku.product.pAvail
  end

  def brand
    sku.vendor.name
  end
end

