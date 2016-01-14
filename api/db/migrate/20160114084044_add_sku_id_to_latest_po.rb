class AddSkuIdToLatestPo < ActiveRecord::Migration
  def change
    PurchaseOrderLineItem.joins('JOIN skus
                                 ON skus.product_name = purchase_orders.orderTool_productName
                                 AND skus.manufacturer_size = purchase_orders.orderTool_brandSize')
                         .where(po_number: '96122')
                         .update_all('purchase_orders.sku_id = skus.id')
  end
end
