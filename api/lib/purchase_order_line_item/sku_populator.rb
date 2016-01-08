class PurchaseOrderLineItem::SkuPopulator
  def populate
    PurchaseOrderLineItem.where(sku_id: nil).find_in_batches.each do |group|
      group.each do |po|
        print "purchase_order: #{po.id}"
        print "  product_id: #{po.product_id}"
        print "  option_id: #{po.option_id}"

        finds = { product_id: po.product_id }
        finds[:option_id] = po.option_id if po.option_id > 0

        populate_sku(po, Sku.find_by!(finds))

        puts ''
      end
    end
  end

  private

  def populate_sku(po, sku)
    po.update!(sku: sku)
    print '  sku_found: true'
  rescue ActiveRecord::RecordNotFound
    print '  sku_found: false'

    if Product.exists?(id: po.product_id)
      print '  product_exists: true'
    else
      print '  product_exists: false'
    end

    if Option.exists?(id: po.option_id)
      print '  option_exists: true'
    else
      print '  option_exists: false'
    end
  end
end
