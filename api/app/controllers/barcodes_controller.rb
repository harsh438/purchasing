class BarcodesController < ApplicationController
  def import
    render json: imported_barcodes
  rescue ActiveRecord::RecordNotFound
    render json: { errors: { skus: ['Some SKUs were not recognised so we did not import any barcodes'] },
                   nonexistant_skus: nonexistant_skus }
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: { barcodes: ['Some barcodes are already associated with SKUs so we did not import any barcodes'] },
                   duplicate_barcodes: duplicate_barcodes }
  end

  private

  def barcodes
    params.require(:barcodes)
  end

  def imported_barcodes
    ActiveRecord::Base.transaction do
      barcodes.map do |barcode|
        sku = Sku.find_by!(sku: barcode[:sku])
        barcode = sku.barcodes.find_or_create_by!(barcode: barcode[:barcode])
        Sku::Exporter.new.export(sku)
        barcode
      end.compact
    end
  end

  def nonexistant_skus
    all_skus = barcodes.map { |barcode| barcode[:sku] }
    existing_skus = Sku.where(sku: all_skus).pluck(:sku)
    all_skus - existing_skus
  end

  def duplicate_barcodes
    Barcode.where(barcode: barcodes.map { |barcode| barcode[:barcode] })
  end
end
