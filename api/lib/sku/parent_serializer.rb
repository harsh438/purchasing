class ParentSerializer < ActiveModel::Serializer
  attributes :id
  attributes :sku
  attributes :price
  attributes :sale_price
  attributes :cost_price
  attributes :barcode
  attributes :brand
  attributes :properties
  attributes :dropshipment
  attributes :use_legacy_slug

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
end
