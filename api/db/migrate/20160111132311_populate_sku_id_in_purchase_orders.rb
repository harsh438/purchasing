class PopulateSkuIdInPurchaseOrders < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      optionless_skus = Sku.joins('INNER JOIN purchase_orders ON skus.product_id = purchase_orders.pID').where('purchase_orders.oID = 0')
      optionless_skus.update_all('purchase_orders.sku_id = skus.id')
      optioned_skus = Sku.joins('INNER JOIN purchase_orders ON skus.product_id = purchase_orders.pID AND skus.option_id = purchase_orders.oID')
      optioned_skus.update_all('purchase_orders.sku_id = skus.id')
    end
  end
end
