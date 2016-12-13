module BatchFiles
  module Processors
    class UpdatePurchaseOrderCostPriceBySku < BatchFiles::Processors::Base
      HEADERS = %w(po sku cost_price).freeze

      validates_presence_of :sku_id, message: 'Sku does not exist for po season'
      validate :existence_of_purchase_order
      validate :cost_price_is_a_number

      def process_method
        ActiveRecord::Base.transaction do
          cost_price_log
          purchase_order_line_item.update_attribute(:cost, cost_price)
        end
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

      def cost_price_log
        CostPriceLog.create(
          purchase_order_number: purchase_order_line_item.po_number,
          product_id: purchase_order_line_item.product_id,
          sku: sku,
          quantity: purchase_order_line_item.quantity,
          before_cost: purchase_order_line_item.cost,
          after_cost: cost_price
        )
      end

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

      def existence_of_purchase_order
        errors[:purchase_order] = 'does not exist' if purchase_order.empty?
      end

      def cost_price_is_a_number
        errors[:cost_price] = 'not a number' unless contents[2].to_s.numeric?
      end
    end
  end
end
