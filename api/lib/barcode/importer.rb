class Barcode::Importer
  def import(barcodes)
    ensure_all_skus_exist!(barcodes)

    ActiveRecord::Base.transaction do
      import_unique_barcodes(barcodes)
    end
  end

  private

  def ensure_all_skus_exist!(barcodes)
    nonexistant_skus = nonexistant_skus(barcodes)

    if nonexistant_skus.any?
      raise SkusNotFound.new(nonexistant_skus)
    end
  end

  def nonexistant_skus(barcodes)
    Sku.nonexistant_skus(barcodes.map { |barcode| barcode[:sku] })
  end

  def import_unique_barcodes(barcodes)
    import_barcodes(unique_and_valid_barcodes(barcodes))
  end

  def import_barcodes(barcodes)
    barcodes.flat_map(&method(:assign_barcode_to_skus))
  rescue BarcodeInvalid
    raise BarcodesInvalid.new(barcodes.map { |b| b.values_at(:sku, :barcode).join(': ') })
  end

  def assign_barcode_to_skus(barcode)
    find_skus(barcode).map do |sku|
      barcode_record = find_or_create_barcode(sku, barcode)
      Sku::Exporter.new.export(sku)
      barcode_record
    end
  end

  def find_skus(barcode)
    skus = Sku.where(sku: barcode[:sku])
    raise SkuNotFound.new(barcode[:sku]) unless skus.any?
    skus
  end

  def find_or_create_barcode(sku, barcode)
    if sku.barcodes.any? && sku.barcodes.map(&:barcode).exclude?(barcode[:barcode])
      Barcode.where(sku_id: sku.id).each do |existing_barcode|
        Barcode::Updater.update(barcode: barcode[:barcode], id: existing_barcode.id)
      end
    else
      sku.barcodes.find_or_create_by!(barcode: barcode[:barcode])
    end
  rescue ActiveRecord::RecordInvalid
    raise BarcodeInvalid.new(barcode)
  end

  def unique_and_valid_barcodes(barcodes)
    barcodes.uniq.select do |barcode|
      barcode[:sku].present?
    end
  end

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
end
