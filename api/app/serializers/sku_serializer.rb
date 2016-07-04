class SkuSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :barcode,
             :category_id,
             :category_name,
             :manufacturer_sku,
             :cost_price,
             :retail_price,
             :manufacturer_color,
             :manufacturer_size,
             :color,
             :size

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
    barcode = (object.barcodes.try(:[], 0).try(:barcode) || '')
    barcode.gsub(/\\.| |\t|\n/, '')
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
