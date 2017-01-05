module BatchFiles
  module Processors
    class BasePurchaseOrderUpdateProcessor < BatchFiles::Processors::Base

      def initialize(scope: PurchaseOrder.new, price_type: CostPrice.new)
        @price_type = price_type
        @scope      = scope
        # @amount = amount
      end

      validates_presence_of :product, message: 'product id does not exist'
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

      def process_method
        purchase_order_lines.map do |purchase_order_line|
          ActiveRecord::Base.transaction do
            cost_price_log(purchase_order_line_item)
            purchase_order_line.update_attributes!(price_type => cost_price)
          end
        end
      end

      private

      attr_reader :scope

      def cost_price_log(purchase_order_line_item)
        CostPriceLog.create(
          purchase_order_number: purchase_order_line_item.po_number,
          product_id: purchase_order_line_item.product_id,
          sku: sku(purchase_order_line_item.sku_id),
          quantity: purchase_order_line_item.quantity,
          before_price: price ,
          after_price: cost_price
        )
      end

      def validations
        # validate the inputs?
      end

      def purchase_order_lines
        scope.scope(contents)
      end

      def update(price_type, amount)
        @price_type.price(purchase_order_line_item)
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

class CostPrice
  def price
    :cost
  end
end

class ListPrice
  def price
    :product_rrp
  end
end

class PurchaseOrderScope
  def scope(params)
    PurchaseOrderLineItem.where(po_number: params[0])
  end

  def name
    :purchase_order
  end
end

class ProductScope
  validates_presence_of :product, message: 'product id does not exist'
  def scope(params)
    PurchaseOrderLineItem.where(po_number: params[0], product_id: params[1])
  end
end

class SkuScope
  validates_presence_of :sku_id, message: 'Sku does not exist for po season'

  def scope(params)
    PurchaseOrderLineItem.where(po_number: params[0], sku_id: params[1])
  end

  def name
    :sku
  end
end
