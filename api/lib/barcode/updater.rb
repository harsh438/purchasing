class Barcode::Updater
  def self.update(params)
    self.check_barcode_uniqueness(params[:barcode], params[:id])
    barcode = Barcode.find(params[:id])
    barcode.barcode = params[:barcode]
    ActiveRecord::Base.transaction do
      barcode.save!
      self.update_barcode_references(barcode)
      barcode.sku.touch
    end
    barcode.sku.barcodes
  end

  private

  def self.check_barcode_uniqueness(barcode, barcode_id)
    barcode = Barcode.find_by(barcode: barcode)
    new_barcode = Barcode.find_by(id: barcode_id)
    if barcode.present? && new_barcode.sku.sku != barcode.sku.sku
      raise Exceptions::BarcodeUpdateUniqueError.new(barcode)
    end
  end

  def self.update_barcode_references(barcode)
    PurchaseOrderLineItem.where(sku: barcode.sku).update_all(orderTool_Barcode: barcode.barcode)
    option = barcode.sku.option
    if option.present?
      option.barcode = barcode.barcode
      option.save!
    end
  end
end
