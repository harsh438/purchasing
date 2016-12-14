module BatchFiles
  module Processors
    class UpdatePurchaseOrderListPriceByPid < BasePurchaseOrderUpdateProcessor
      HEADERS = %w(po product_id list_price).freeze

      validate :list_price_is_a_number

      def process_method
        purchase_order_lines.map do |purchase_order_line|
          ActiveRecord::Base.transaction do
            purchase_order_line.update_attributes!(product_rrp: list_price)
            sku(purchase_order_line.sku_id).update_attributes!(price: list_price)
          end
        end
      end

      private

      def list_price
        contents[2].to_f.round(2)
      end

      def list_price_is_a_number
        errors[:list_price] = 'not a number' unless contents[2].to_s.numeric?
      end
    end
  end
end
