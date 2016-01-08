desc 'Migrate legacy products to SKUs table'
namespace :legacy do
  task product_migrate: :environment do
    Product::Migrator.new.migrate
  end

  task po_line_item_sku_id_populate: :environment do
    PurchaseOrderLineItem::SkuIdPopulator.new.populate
  end

  task po_line_item_negative_sku_populate: :environment do
    PurchaseOrderLineItem::NegativeSkuPopulator.new.populate
  end
end
