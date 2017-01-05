module BatchFiles
  module Processors
    class UpdatePurchaseOrderCostPriceBySku < BatchFiles::Processors::Base

      def initilaize
        @base_class = BasePurchaseOrderUpdateProcessor.new(scope: SkuScope.new)
      end

      HEADERS = %w(po sku cost_price).freeze

      validates_presence_of :sku_id, message: 'Sku does not exist for po season'
      validates_presence_of :purchase_order, message: 'does not exist'
      validate :cost_price_is_a_number

      def process_method
         @base_class.process_method
      end

      def self.valid_csv(batch_file_contents, errors)
        validate_header(batch_file_contents, errors, *HEADERS)
      end

      def self.sample_file
        [
          HEADERS,
          %w(1001 9119-11 20),
          %w(1001 9120-11 20)
        ]
      end

      private


      def purchase_order_line_item
        @purchase_order_line_item ||= PurchaseOrderLineItem
                                      .find_by!(po_number: po_number,
                                                sku_id: sku_id)
      end

      def sku_id
        @sku_id ||= Sku.where(sku: sku, season: season).pluck(:id).first
      end

      def season
        @season ||= PurchaseOrderLineItem.season(po_number)
      end

      def purchase_order
        PurchaseOrder.where(po_num: po_number)
      end

      def po_number
        contents[0]
      end

      def sku
        contents[1]
      end

      def cost_price
        contents[2].to_f
      end

      def cost_price_is_a_number
        errors[:cost_price] = 'not a number' unless contents[2].to_s.numeric?
      end
    end
  end
end
