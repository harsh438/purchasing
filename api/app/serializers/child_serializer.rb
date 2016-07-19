class ChildSerializer < ActiveModel::Serializer
  attributes :sku, :price, :cost_price, :barcode,
             :legacy_brand_size, :options

  private

  def sku
    object.sku
  end

  def price
    object.price
  end

  def cost_price
    object.cost_price
  end

  def barcode
    object.barcodes.first.barcode
  end

  def legacy_brand_size
    object.manufacturer_size
  end

  def options
    {
      size: object.size
    }
  end
end
