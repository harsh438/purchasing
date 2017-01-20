module BatchFiles
  module Processors
    class UpdatePurchaseOrderProductRRPBySku < BatchFiles::Processors::Base
         HEADERS = %w(po sku product_rrp).freeze

      validates_presence_of :sku_id, message: 'Sku does not exist for po season'
      validates_presence_of :purchase_order, message: 'does not exist'
      validate :product_rrp_is_a_number

      def process_method
        ActiveRecord::Base.transaction do
          purchase_order_line_item.update_attributes(product_rrp: product_rrp)
        end
      end

      def self.valid_csv(batch_file_contents, errors)
        validate_header(batch_file_contents, errors, *HEADERS)
      end

      def self.sample_file
        [
          HEADERS,
          %w(1001 9119-11 20),
          %w(1001 9120-13 19.99)
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

      def product_rrp
        contents[2].to_f.round(2)
      end

      def product_rrp_is_a_number
        errors[:product_rrp] = 'not a number' unless contents[2].to_s.numeric?
      end
    end
  end
end
