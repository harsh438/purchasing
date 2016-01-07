class BarcodesController < ApplicationController
  def import
    render json: imported_barcodes
  end

  private

  def barcodes
    params.require(:barcodes)
  end

  def imported_barcodes
    ActiveRecord::Base.transaction do
      barcodes.map do |barcode|
        sku = Sku.find_by(sku: barcode[:sku])

        begin
          if sku.present?
            barcode = sku.barcodes.create!(barcode: barcode[:barcode])
            Sku::Exporter.new.export(sku)
            barcode
          end
        rescue ActiveRecord::RecordNotUnique
        end
      end.compact
    end
  end
end
