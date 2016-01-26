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
    import_barcodes(unique_and_valid_barcodes(barcodes))
  end

  def import_barcodes(barcodes)
    barcodes.flat_map(&method(:assign_barcode_to_skus))
  rescue SkuNotFound
    raise SkusNotFound.new(nonexistant_skus(barcodes))
  rescue BarcodeInvalid
    raise BarcodesInvalid.new(barcodes)
  end

  def assign_barcode_to_skus(barcode)
    find_skus(barcode).map do |sku|
      barcode = find_or_create_barcode(sku, barcode)
      Sku::Exporter.new.export(sku)
      barcode
    end
  end

  def find_skus(barcode)
    skus = Sku.where(sku: barcode[:sku])
    raise SkuNotFound.new(barcode[:sku]) unless skus.any?
    skus
  end

  def find_or_create_barcode(sku, barcode)
    sku.barcodes.find_or_create_by!(barcode: barcode[:barcode])
  rescue ActiveRecord::RecordInvalid
    raise BarcodeInvalid.new(barcode)
  end

  def nonexistant_skus(barcodes)
    Sku.nonexistant_skus(barcodes.map { |barcode| barcode[:sku] })
  end

  def unique_and_valid_barcodes(barcodes)
    barcodes.uniq.select do |barcode|
      barcode[:sku].present? and barcode[:barcode].present?
    end
  end
end
