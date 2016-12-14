module BatchFiles
  module Processors
    class UpdatePurchaseOrderSupplierCostPrice < BasePurchaseOrderUpdateProcessor
      HEADERS = %w(po product_id supplier_cost_price).freeze

      validate :supplier_cost_price_is_a_number

      def process_method
        purchase_order_lines.map do |purchase_order_line|
          ActiveRecord::Base.transaction do
            purchase_order_line.update_attributes!(supplier_list_price: supplier_cost_price)
          end
        end
      end

      private

      def supplier_cost_price
        contents[2].to_f.round(2)
      end

      def supplier_cost_price_is_a_number
        errors[:supplier_cost_price] = 'not a number' unless contents[2].to_s.numeric?
      end
    end
  end
end
