module BatchFiles
  module Processors
    class UpdatePurchaseOrderCostPriceByPid < BatchFiles::Processors::Base

      def initilaize
        @base_class = BasePurchaseOrderUpdateProcessor.new(scope: ProductScope.new)
      end

      HEADERS = %w(po product_id cost_price).freeze

      validate :cost_price_is_a_number

      def process_method
        base_class.process_method
      end

      private

      attr_reader :base_class

      def cost_price
        contents[2].to_f.round(2)
      end

      def cost_price_is_a_number
        errors[:cost_price] = 'not a number' unless contents[2].to_s.numeric?
      end
    end
  end
end
