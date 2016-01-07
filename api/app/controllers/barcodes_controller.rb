class BarcodesController < ApplicationController
  def import
    render json: imported_barcodes
  rescue ActiveRecord::RecordNotUnique
    render json: { error: 'Some barcodes are already associated with SKUs so we did not import any',
                   duplicate_barcodes: duplicate_barcodes }
  end

  private

  def barcodes
    params.require(:barcodes)
  end

  def imported_barcodes
    ActiveRecord::Base.transaction do
      barcodes.map do |barcode|
        sku = Sku.find_by(sku: barcode[:sku])

        if sku.present?
          barcode = sku.barcodes.find_or_create_by!(barcode: barcode[:barcode])
          Sku::Exporter.new.export(sku)
          barcode
        end
      end.compact
    end
  end

  def duplicate_barcodes
    Barcode.where(barcode: barcodes.map { |barcode| barcode[:barcode] })
  end
end
