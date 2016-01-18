class Product::MissingMigrator
  def migrate_missing_barcodes
    skus_missing_barcodes.each do |sku|
      create_barcode(sku)
    end
  end

  def migrate_missing_skus_data
    skus_missing_data.each do |sku|
      create_missing_sku_data(sku)
    end
  end

  private

  def skus_missing_barcodes
    Sku.select(:id, :product_id, :size).where('id NOT IN (SELECT sku_id FROM barcodes)')
  end

  def create_barcode(sku)
    Barcode.create!(sku: sku,
                    barcode: options_for_sku(sku).oSizeB)
  end

  def options_for_sku(sku)
    Option.joins('INNER JOIN ds_language_product_options ON ds_language_product_options.oID = ds_options.oID')
          .where('ds_language_product_options.pID = ?', sku.product_id)
          .where('ds_language_product_options.pOption = ?', sku.size)
          .first
  end

  def skus_missing_data
    Sku.where('option_id IS NULL AND manufacturer_size IS NULL')
  end

  def create_missing_sku_data(sku)
    options = options_for_sku(sku)

    sku.update!(option_id: options.oID,
                manufacturer_size: options.oSizeL)
  end
end
