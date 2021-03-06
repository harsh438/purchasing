class BarcodesController < ApplicationController
  def import
    render json: Barcode::Importer.new.import(barcodes)
  rescue Barcode::Importer::SkusNotFound => e
    render json: { errors: { skus: ['Some SKUs were not recognised so we did not import any barcodes'] },
           nonexistant_skus: e.nonexistant_skus }
  rescue Barcode::Importer::BarcodesInvalid => e
    render json: { errors: { skus: ['Some barcodes were invalid. Can you check them and try again?'] },
           nonexistant_skus: e.invalid_barcodes }
  rescue Sku::Exporter::ProductWithoutColor => e
    render json: { errors: { skus: [e.message] } }
  end

  def update
    render json: { barcodes: Barcode::Updater.update(params).as_json }
  rescue Exceptions::BarcodeUpdateUniqueError => e
    render json: {
      message: e.message.as_json,
      duplicated_sku: e.duplicate.sku.as_json_with_vendor_category_and_barcodes,
      barcode: e.duplicate.as_json
    }, status: 409
  rescue Exceptions::BarcodeUpdateError => e
    return render json: { message: e.message }, status: 422
  end

  private

  def barcodes
    params.require(:barcodes)
  end
end
