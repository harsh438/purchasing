module CostPrice
  class ActualCost < CostPrice::Base
    def process_csv(csv_data)
      purchase_order_updated = csv_data.map do |data|
        @before_product = false
        log('Purchase order', data[:po])
        log('Product Id', data[:product_id])
        lines = purchase_order_details(data[:po], data[:product_id])
        update_cost_prices(lines, data[:actual_cost])
        "product_id :#{data[:product_id]} for #{data[:po]}"
      end
      "Updated #{purchase_order_updated.join(',')}"
    end

    def update_cost_prices(purchase_order_lines, cost_price)
      purchase_order_lines.map do |purchase_order_line|
        log('Purchase order pid', purchase_order_line.try(:product_id))
        log('old cost price', purchase_order_line.try(:cost))
        update_purchase_order_cost(purchase_order_line, cost_price)
        log('new cost price', cost_price)
        update_sku_cost_price(purchase_order_line.sku_id, cost_price)
        product_id = purchase_order_line.try(:product_id)
        update_product_cost_price(product_id, cost_price)
        log_count_increment
      end
      true
    end

    private

    def purchase_order_details(purchase_order_number, product_id)
      PurchaseOrderLineItem.where('po_number = ? and pid = ?',
                                  purchase_order_number, product_id)
    end

  end
end
