class Barcode::Importer
  class SkuNotFound < RuntimeError; end

  class SkusNotFound < RuntimeError
    attr_reader :nonexistant_skus

    def initialize(nonexistant_skus)
      @nonexistant_skus = nonexistant_skus
    end
  end

  class BarcodeInvalid < RuntimeError;  end

  class BarcodesInvalid < RuntimeError
    attr_reader :invalid_barcodes

    def initialize(invalid_barcodes)
      @invalid_barcodes = invalid_barcodes
    end
  end

  def import(barcodes)
    ActiveRecord::Base.transaction do
      import_unique_barcodes(barcodes)
    end
  end

  private

  def import_unique_barcodes(barcodes)
    import_barcodes(barcodes.uniq)
  end

  def import_barcodes(barcodes)
    barcodes.map(&method(:import_barcode))
  rescue SkuNotFound
    raise SkusNotFound.new(nonexistant_skus(barcodes))
  rescue BadBarcode
    raise BarcodesInvalid.new(invalid_barcodes(barcodes))
  end

  def import_barcode(barcode)
    sku = find_sku(barcode)
    barcode = find_or_create_barcode(sku, barcode)
    Sku::Exporter.new.export(sku)
    barcode
  end

  def find_sku(barcode)
    Sku.find_by!(sku: barcode[:sku], manufacturer_size: barcode[:brand_size])
  rescue ActiveRecord::RecordNotFound
    raise SkuNotFound.new(barcode[:sku])
  end

  def find_or_create_barcode(sku, barcode)
    sku.barcodes.find_or_create_by!(barcode: barcode[:barcode])
  rescue ActiveRecord::RecordInvalid
    raise BarcodeInvalid.new(barcode)
  end

  def nonexistant_skus(barcodes)
    Sku.nonexistant_skus(barcodes.map { |barcode| barcode[:sku] })
  end

  def invalid_barcodes(barcodes)
    barcodes.map do |barcode|
      barcode unless barcode[:sku].present? and
                     barcode[:brand_size].present? and
                     barcode[:barcode].present?
    end.compact
  end
end
