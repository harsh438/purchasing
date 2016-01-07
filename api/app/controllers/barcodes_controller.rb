class BarcodesController < ApplicationController
  def import
    render json: imported_barcodes
  end

  private

  def barcodes
    params.require(:barcodes)
  end

  def imported_barcodes
    barcodes.map do |barcode|
      sku = Sku.find_by(sku: barcode[:sku])

      if sku.present?
        barcode = sku.barcodes.create!(barcode: barcode[:barcode])
        Sku::Exporter.new.export(sku)
        barcode
      end
    end.compact
  end
end
