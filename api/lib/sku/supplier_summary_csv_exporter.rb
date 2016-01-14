class Sku::SupplierSummaryCsvExporter
  def export(params)
    csv = Csv::ViewModel.new
    csv << columns
    csv.concat(find_skus(params))
  end

  private

  def columns
    %w(barcode
       surfdome_sku
       item_code
       brand_color_code
       brand_product_name
       brand_color_name
       brand_size)
  end

  def find_skus(params)
    skus = Sku::Search.new.search(params)
    values_from_skus(skus)
  end

  def values_from_skus(skus)
    skus.map do |sku|
      [sku.barcodes.first.try(:barcode),
       sku.sku,
       sku.manufacturer_sku,
       brand_color_code(sku.manufacturer_sku),
       sku.product_name,
       sku.manufacturer_color,
       sku.manufacturer_size]
    end
  end

  def brand_color_code(brand_sku)
    if brand_sku.include?('-')
      brand_sku.split('-').last
    else
      ''
    end
  end
end
