class Hub::SpreeProductInfo < ApplicationController

  def latest
    params = params[:parameters]

    last_imported_id = params[:last_imported_pid]
    import_limit = params[:import_limit]
    last_imported_timestamp = params[:last_imported_timestamp]

    products = eligible_products

    skus = Sku.where('product_id in (?)',  products.map(&:product_id).split(","))

    skus.each { | sku | build_json(sku) }
  end

  private

  attr_reader :children, :legacy_info, :parent, :images

  def eligible_products
    Sku.includes(:language_category)
              .includes(:barcodes)
              .product_updated_since(last_imported_timestamp, last_imported_pid)
              .with_barcode
              .order(updated_at: :asc, product_id: :asc)
              .group(:product_id)
              .limit(import_limit)
  end

  def build_json(sku)
    {
      Parent.new(sku).as_json,
      LegacyInfo.new(sku).as_json,
      children: Children.new(sku).as_json,
      images: Images.new(sku).as_json,
      contents: Content.new(sku).asjson,
    }
  end
end
