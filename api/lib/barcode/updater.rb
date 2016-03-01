class Barcode::Updater
  def self.update(params)
    self.check_barcode_uniqueness(params[:barcode])
    barcode = Barcode.find(params[:id])
    barcode.barcode = params[:barcode]
    ActiveRecord::Base.transaction do
      barcode.save!
      self.update_barcode_references(barcode)
    end
    barcode.sku.barcodes
  end

  def self.check_barcode_uniqueness(barcode)
    if Barcode.find_by(barcode: barcode).present?
      raise Exceptions::BarcodeUpdateError, "Barcode #{barcode} is not unique"
    end
  end

  private
  def self.update_barcode_references(barcode)
    PurchaseOrderLineItem.where(sku: barcode.sku).update_all(orderTool_Barcode: barcode.barcode)
  end
end
