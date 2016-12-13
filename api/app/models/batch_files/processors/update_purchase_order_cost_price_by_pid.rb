module BatchFiles
  module Processors
    class UpdatePurchaseOrderCostPriceByPid < BatchFiles::Processors::Base
      HEADERS = %w(po product_id cost_price).freeze

      validates_presence_of :product, message: 'product id does not exists'
      validate :existence_of_purchase_order
      validate :existence_of_purchase_order_product
      validate :cost_price_is_a_number

      def process_method
        purchase_order_lines.map do |purchase_order_line|
          ActiveRecord::Base.transaction do
            cost_price_log(purchase_order_line)
            update_purchase_order_cost(purchase_order_line, cost_price)
          end
        end
      end

      def self.valid_csv(batch_file_contents, errors)
        validate_header(batch_file_contents, errors, *HEADERS)
      end

      def self.sample_file
        [
          HEADERS,
          %w(1001 9119-11 20),
          %w(1001 9120-11 20),
        ]
      end

      private

      def update_purchase_order_cost(purchase_order_line, cost_price)
        purchase_order_line.cost = cost_price.round(2)
        purchase_order_line.save!
      end


      def cost_price_log(purchase_order_line_item)
        CostPriceLog.create(
          purchase_order_number: purchase_order_line_item.po_number,
          product_id: product_id,
          sku: sku(purchase_order_line_item.sku_id),
          quantity: purchase_order_line_item.quantity,
          before_cost: purchase_order_line_item.cost,
          after_cost: cost_price
        )
      end

      def purchase_order_lines
        PurchaseOrderLineItem.where(po_number: po_number, pid: product_id)
      end

      def product
        @product ||= Product.where(pid: product_id).pluck(:pid).first
      end

      def sku(sku_id)
        Sku.where(id: sku_id).pluck(:sku).first
      end

      def purchase_order
        PurchaseOrder.where(po_num: po_number)
      end

      def po_number
        contents[0]
      end

      def product_id
        contents[1]
      end

      def cost_price
        contents[2].to_f
      end

      def existence_of_purchase_order
        errors[:purchase_order] = 'does not exist' if purchase_order.empty?
      end

      def existence_of_purchase_order_product
        if purchase_order_lines.empty?
         errors[:purchase_order_product] = 'pid does not exist in this po'
        end
      end

      def cost_price_is_a_number
        errors[:cost_price] = 'not a number' unless contents[2].to_s.numeric?
      end
    end
  end
end
