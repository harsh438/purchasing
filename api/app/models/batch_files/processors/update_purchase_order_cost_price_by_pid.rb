module BatchFiles
  module Processors
    class UpdatePurchaseOrderCostPriceByPid < BatchFiles::Processors::Base
      HEADERS = %w(po product_id cost_price).freeze

      def self.valid_csv(batch_file_contents, errors)
        validate_header(batch_file_contents, errors, *self::HEADERS)
      end

      def self.sample_file
        [
          HEADERS,
          %w(1001 1234 20.99),
          %w(1001 1235 10.12),
        ]
      end

      def process_method
        binding.pry
        base_class = BasePurchaseOrderUpdateProcessor.new(
          batch_file_line,
          scope: ProductScope.new,
          amount: amount
        )
        base_class.process_method
      end

      private

      def amount
        contents[2].to_f.round(2)
      end
    end
  end
end
