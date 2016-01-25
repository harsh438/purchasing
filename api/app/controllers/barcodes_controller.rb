class BarcodesController < ApplicationController
  def import
    render json: Barcode::Importer.new.import(barcodes)
  rescue Barcode::Importer::SkusNotFound => e
    render json: { errors: { skus: ['Some SKUs were not recognised so we did not import any barcodes'] },
           nonexistant_skus: e.nonexistant_skus }
  rescue Barcode::Importer::BarcodesInvalid => e
    render json: { errors: { skus: ['Some records were missing or invalid'] },
           nonexistant_skus: e.invalid_barcodes }
  end

  private

  def barcodes
    params.require(:barcodes)
  end
end
