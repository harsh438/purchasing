namespace :purchase_order do
  desc 'updates a 0 supplier cost price to the correct amount'
  task :update_supplier_cost_price, [:sku_id] => :environment do |_t, args|
    sku_id = args[:sku_id]

    new_price = PurchaseOrderLineItem.find_by(
      'sku_id = ? AND operator != ? AND orderTool_SupplierListPrice > ?',
      sku_id, 'O_U_TOOL', 0).supplier_cost_price

    PurchaseOrderLineItem.where(
      'sku_id = ? AND operator = ? AND (orderTool_SupplierListPrice = ? OR orderTool_SupplierListPrice is null OR orderTool_SupplierListPrice = ?)',
      sku_id, 'O_U_TOOL', 0,'').update_all(orderTool_SupplierListPrice: new_price)
  end
end
