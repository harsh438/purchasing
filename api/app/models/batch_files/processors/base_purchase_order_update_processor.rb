module BatchFiles
  module Processors
    class BasePurchaseOrderUpdateProcessor < BatchFiles::Processors::Base

      validates_presence_of :product, message: 'product id does not exists'
      validates_presence_of :purchase_order, message: 'does not exist'
      validates_presence_of :purchase_order_lines, message: 'pid does not exist in this po'

      def self.valid_csv(batch_file_contents, errors)
        validate_header(batch_file_contents, errors, *self::HEADERS)
      end

      def self.sample_file
        [
          self::HEADERS,
          %w(1001 9119-11 20),
          %w(1001 9120-11 20),
        ]
      end

      private

      def purchase_order_lines
        PurchaseOrderLineItem.where(po_number: po_number, pid: contents[1])
      end

      def product
        @product ||= Product.find_by(id: contents[1])
      end

      def po_number
        contents[0]
      end

      def sku(sku_id)
        Sku.find_by(id: sku_id)
      end

      def purchase_order
        PurchaseOrder.where(po_num: po_number)
      end
    end
  end
end
