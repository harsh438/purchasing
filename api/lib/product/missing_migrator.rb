class Product::MissingMigrator
  class NoProductOptions < RuntimeError; end

  def migrate_missing_barcodes
    skus_missing_barcodes.each do |sku|
      begin
        create_barcode(sku)
      rescue NoProductOptions => e
        puts e
      end
    end
  end

  def migrate_missing_skus_data
    skus_missing_data.each do |sku|
      begin
        create_missing_sku_data(sku)
      rescue NoProductOptions => e
        puts e
      end
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
    options = Option.joins('INNER JOIN ds_language_product_options ON ds_language_product_options.oID = ds_options.oID')
                    .where('ds_language_product_options.pID = ?', sku.product_id)
                    .where('ds_language_product_options.pOption = ?', sku.size)
                    .where('ds_options.oSizeB IS NOT NULL')

    if options.length < 1
      raise NoProductOptions, "No options found for product_id `#{sku.product_id}` and size `#{sku.size}`"
    end

    options.first
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
