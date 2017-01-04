namespace :sku do
  desc 'reconciles sku sizes across seasons, such that the same skus will have the same size.'
  task :reconcile_sizes, [:sku] => :environment do |_t, args|
    internal_sku = args[:sku]
    element_id = internal_sku.split("-")[-1]
    size = Element.find_by!(id: element_id).name
    skus = Sku.where(sku: internal_sku)

    skus.each do |sku|
      sku.update_attributes!(size: size)
      PurchaseOrderLineItem.where(sku_id: sku.id).update_all(orderTool_SDsize: size)
    end
  end
end
