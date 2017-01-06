module BatchFiles
  module Processors
    class UpdatePurchaseOrderCostPriceByPid < BatchFiles::Processors::Base
      HEADERS = %w(po product_id cost_price).freeze

      def self.sample_file
        [
          HEADERS,
          %w(1001 9119-11 20),
          %w(1001 9120-11 20),
        ]
      end

      def process_method
        base_class = BasePurchaseOrderUpdateProcessor.new(scope: ProductScope.new)
        base_class.process_method
      end
    end
  end
end
