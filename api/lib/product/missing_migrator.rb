class Product::MissingMigrator
  def migrate_missing_barcodes
    skus_missing_barcodes.each do |sku|
      create_barcode(sku)
    end
  end

  private

  def skus_missing_barcodes
    Sku.select(:id, :product_id, :size).where('id NOT IN (SELECT sku_id FROM barcodes)')
  end

  def create_barcode(sku)
    Barcode.create!(sku: sku,
                    barcode: barcode_for_sku(sku))
  end

  def barcode_for_sku(sku)
    option = Option.joins('INNER JOIN ds_language_product_options ON ds_language_product_options.oID = ds_options.oID')
                   .where('ds_language_product_options.pID = ?', sku.product_id)
                   .where('ds_language_product_options.pOption = ?', sku.size)
                   .first

    option.oSizeB
  end
end
