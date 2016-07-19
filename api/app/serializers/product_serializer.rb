class ProductSerializer < ActiveModel::Serializer
  attributes :id, :sku, :price, :cost_price, :sale_price,
             :active, :barcode, :brand, :properties,
             :dropshipment, :use_legacy_slug, :images,
             :legacy_lead_gender,
             :legacy_reporting_category,
             :legacy_season,
             :legacy_supplier_sku,
             :legacy_reporting_category_name,
             :legacy_first_received_at,
             :legacy_more_from_category,
             :parts,
             :children,
             :contents,
             :options

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

  def images
    object.product_images.map do |product_image|
      product_image.as_json
    end
  end

  def legacy_lead_gender
    object.master_sku.gender
  end

  def legacy_reporting_category
    object.master_sku.reporting_category.category_id
  end

  def legacy_season
    object.master_sku.season
  end

  def legacy_supplier_sku
    object.manufacturer_sku
  end

  def legacy_reporting_category_name
    object.master_sku.language_category.catName
  end

  def legacy_first_received_at
    object.master_sku.first_received
  end

  def legacy_more_from_category
    object.master_sku.ordered_category_id
  end

  def parts
    object.kit_managers.map(&:item_code)
  end

  def children
    return [] if object.skus.length <= 1
    object.skus.map do |sku|
      ChildSerializer.new(sku).as_json
    end
  end

  def contents
    object.language_products.map do |language_product|
      ContentSerializer.new(language_product).as_json
    end
  end

  def options
    return [] if object.skus.length <= 1
    "Size"
  end
end
