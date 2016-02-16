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

  def name
    object.product_name
  end

  def barcode
    object.product.barcode
  end

  def retail_price
    object.list_price
  end
end
