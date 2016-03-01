class BarcodesController < ApplicationController
  def import
    render json: Barcode::Importer.new.import(barcodes)
  rescue Barcode::Importer::SkusNotFound => e
    render json: { errors: { skus: ['Some SKUs were not recognised so we did not import any barcodes'] },
           nonexistant_skus: e.nonexistant_skus }
  rescue Barcode::Importer::BarcodesInvalid => e
    render json: { errors: { skus: ['Some barcodes were invalid. Can you check them and try again?'] },
           nonexistant_skus: e.invalid_barcodes }
  end

  def update
    render json: { barcodes: Barcode::Updater.update(params).as_json }
  end

  private

  def barcodes
    params.require(:barcodes)
  end
end
