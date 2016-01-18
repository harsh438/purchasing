desc 'Migrate legacy products to SKUs table'
namespace :legacy do
  task product_migrate: :environment do
    Product::Migrator.new.migrate
  end

  task po_line_item_negative_sku_populate: :environment do
    PurchaseOrderLineItem::NegativeSkuPopulator.new.populate
  end

  task product_migrate_missing: :environment do
    Product::MissingMigrator.new.migrate_missing_barcodes
    Product::MissingMigrator.new.migrate_missing_skus_data
  end
end
