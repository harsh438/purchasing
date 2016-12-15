module BatchFiles
  module Processors
    class UpdatePurchaseOrderCostPriceByPid < BasePurchaseOrderUpdateProcessor
      HEADERS = %w(po product_id cost_price).freeze

      validate :cost_price_is_a_number

      def process_method
        purchase_order_lines.map do |purchase_order_line|
          ActiveRecord::Base.transaction do
            cost_price_log(purchase_order_line)
            purchase_order_line.update_attributes!(cost: cost_price)
          end
        end
      end

      private

      def cost_price_log(purchase_order_line_item)
        CostPriceLog.create(
          purchase_order_number: purchase_order_line_item.po_number,
          product_id: product.id,
          sku: sku(purchase_order_line_item.sku_id),
          quantity: purchase_order_line_item.quantity,
          before_cost: purchase_order_line_item.cost,
          after_cost: cost_price
        )
      end

      def cost_price
        contents[2].to_f.round(2)
      end

      def cost_price_is_a_number
        errors[:cost_price] = 'not a number' unless contents[2].to_s.numeric?
      end
    end
  end
end
