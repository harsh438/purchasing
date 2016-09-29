module CostPrice
  class PurchaseOrderByPercent < CostPrice::Base

    def process_csv(csv_data)
      purchase_order_updated = csv_data.map do |data|
        @before_product = false
        log('Purchase order', data[:po])
        lines = purchase_order_details(data[:po])
        update_cost_prices(lines, data[:discount])
        data[:po]
      end
      "Updated Purchase Orders #{purchase_order_updated.join(',')}"
    end

    private

    def update_cost_prices(purchase_order_lines, discount)
      purchase_order_lines.map do |purchase_order_line|
        log('Purchase order pid', purchase_order_line.try(:product_id))
        log('old cost price', purchase_order_line.try(:cost))
        supplier_price = purchase_order_line.try(:orderTool_SupplierListPrice)
        cost_price = calculate_cost_price(supplier_price, discount)
        update_purchase_order_cost(purchase_order_line, cost_price)
        log('new cost price', cost_price)
        update_sku_cost_price(purchase_order_line.sku_id, cost_price)
        product_id = purchase_order_line.try(:product_id)
        update_product_cost_price(product_id, cost_price)
        log_count_increment
      end
      true
    end

    def purchase_order_details(purchase_order_number)
      PurchaseOrderLineItem.where(po_number: purchase_order_number)
    end

    def calculate_cost_price(price, discount_percent)
      discount = (price / 100) * discount_percent.to_f
      price - discount
    end
  end
end
