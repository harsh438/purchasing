class Barcode::Updater
  def self.update(params)
    self.check_barcode_uniqueness(params[:barcode])
    barcode = Barcode.find(params[:id])
    self.check_editable(barcode)
    barcode.barcode = params[:barcode]
    ActiveRecord::Base.transaction do
      barcode.save!
      self.update_barcode_references(barcode)
    end
    barcode.sku.barcodes
  end

  private
  def self.check_editable(barcode)
    unless barcode.sku.sized?
      raise Exceptions::BarcodeUpdateError, "Unsized skus are not editable."
    end
  end

  def self.check_barcode_uniqueness(barcode)
    barcode = Barcode.find_by(barcode: barcode)
    if barcode.present?
      raise Exceptions::BarcodeUpdateUniqueError.new(barcode), "Barcode #{barcode} is not unique"
    end
  end

  def self.update_barcode_references(barcode)
    PurchaseOrderLineItem.where(sku: barcode.sku).update_all(orderTool_Barcode: barcode.barcode)
  end
end
