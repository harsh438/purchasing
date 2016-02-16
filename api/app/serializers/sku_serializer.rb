class SkuSerializer < ActiveModel::Serializer
  attributes :id
  attributes :name
  attributes :barcode
  attributes :category_id
  attributes :category_name
  attributes :manufacturer_sku
  attributes :cost_price
  attributes :retail_price
  attributes :manufacturer_color
  attributes :manufacturer_size
  attributes :color
  attributes :size

  def id
    object.sku
  end

  def category_name
    object.language_category.try(:name)
  end

  def name
    object.product_name
  end

  def barcode
    object.barcodes.try(:[], 0).try(:barcode) || ''
  end

  def retail_price
    object.list_price || 0
  end

  def cost_price
    object.cost_price || 0
  end

  def manufacturer_color
    object.manufacturer_color || ''
  end

  def manufacturer_size
    object.manufacturer_size || ''
  end

  def color
    object.color || ''
  end

  def size
    object.size || ''
  end
end
