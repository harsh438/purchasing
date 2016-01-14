class AddSkuIdToLatestPo < ActiveRecord::Migration
  def change
    # PurchaseOrderLineItem.where(po_number: '96122').each do |po_line_item|
    #   sku = Sku.find_by(product_name: po_line_item.brand_product_name,
    #                     brand_size: po_line_item.brand_size)
    #
    #   if sku.present?
    #     po_line_item.update!(sku: sku)
    #   end
    # end

    PurchaseOrderLineItem.logger = Logger.new(STDOUT)
    PurchaseOrderLineItem.joins('JOIN skus ON skus.product_name = purchase_orders.orderTool_productName
                                 AND skus.manufacturer_size = purchase_orders.orderTool_brandSize')
                         .where(po_number: '96122')
                         .update_all('purchase_orders.sku_id = skus.id')
  end
end
