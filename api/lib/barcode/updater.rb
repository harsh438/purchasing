class Barcode::Updater
  def self.update(params)
    barcode = Barcode.find_by(barcode: params[:old_barcode])
    barcode.barcode = params[:new_barcode]
    ActiveRecord::Base.transaction do
      barcode.save!
      self.update_barcode_references(barcode)
    end
    barcode
  end

  private
  def self.update_barcode_references(barcode)
    PurchaseOrderLineItem.where(sku: barcode.sku).update_all(orderTool_Barcode: barcode.barcode)
  end
end
