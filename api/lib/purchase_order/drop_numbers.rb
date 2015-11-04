class PurchaseOrder::DropNumbers
  def calculate(results)
    total_drops = find_total_drops(results)
    return {} unless total_drops.any?

    criteria = results.reduce([]) do |criteria, purchase_order|
      if purchase_order.product_id > 0 and purchase_order.option_id > 0
        criteria << purchase_order.product_id
        criteria << purchase_order.option_id
        criteria << purchase_order.drop_date
      else
        criteria
      end
    end

    query = (criteria.count / 3).times.map { '(pID = ? AND oID = ? AND drop_date < ?)' }.join(' OR ')

    drops_before = PurchaseOrder.with_summary
                                .with_valid_status
                                .where(query, *criteria)
                                .group(:drop_date, :pID, :oID)
                                .count

    drops = {}

    results.each do |purchase_order|
      drops_before_key = [purchase_order.delivery_date,
                          purchase_order.product_id,
                          purchase_order.option_id]

      total_drops_key = [purchase_order.product_id,
                         purchase_order.option_id]

      drops_before_value = (drops_before[drops_before_key] || 0) + 1

      drops[purchase_order.id] = "#{drops_before_value}/#{total_drops[total_drops_key]}"
    end

    drops
  end

  private

  def find_total_drops(results)
    criteria = results.reduce([]) do |criteria, purchase_order|
      if purchase_order.product_id > 0 and purchase_order.option_id > 0
        criteria << purchase_order.product_id
        criteria << purchase_order.option_id
      else
        criteria
      end
    end

    return PurchaseOrder.none unless criteria.count > 0

    query = (criteria.count / 2).times.map { '(pID = ? AND oID = ?)' }.join(' OR ')

    PurchaseOrder.with_summary
                 .with_valid_status
                 .where(query, *criteria)
                 .group(:pID, :oID)
                 .count
  end
end
