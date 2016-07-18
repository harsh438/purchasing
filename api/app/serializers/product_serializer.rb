class ProductSerializer < ActiveModel::Serializer
  attributes :id,:sku, :price, :cost_price, :sale_price,
             :active, :barcode, :brand, :properties,
             :dropshipment, :use_legacy_slug

  private

  def brand
    object.vendor.name
  end

  def use_legacy_slug
    true
  end

  def sku
    object.id
  end

  def cost_price
    object.cost
  end

  def properties
    {
      gender: object.listing_genders,
      colour: object.color
    }
  end

  def barcode
    object.master_sku.barcodes.latest.barcode
  end
end
