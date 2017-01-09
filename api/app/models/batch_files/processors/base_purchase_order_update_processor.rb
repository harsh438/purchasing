module BatchFiles
  module Processors
    class BasePurchaseOrderUpdateProcessor < BatchFiles::Processors::Base
      def initialize(batch_file_line, scope: PurchaseOrder.new, price: CostPrice.new, amount:)
        super(batch_file_line)
        @price   = price
        @scope   = scope
        @amount  = amount
      end

      validate :validations
      validates_presence_of :purchase_order, message: 'does not exist'

      def self.valid_csv(batch_file_contents, errors)
        validate_header(batch_file_contents, errors, *self::HEADERS)
      end

      def process_method
        purchase_order_lines.map do |purchase_order_line|
          ActiveRecord::Base.transaction do
            binding.pry
            # cost_price_log(purchase_order_line)
            purchase_order_line.update_attributes!({ price.type => amount })
          end
        end
      end

      private

      attr_reader :scope, :price, :amount

      def cost_price_log(purchase_order_line_item)
        CostPriceLog.create(
          purchase_order_number: purchase_order_line_item.po_number,
          product_id: purchase_order_line_item.product_id,
          sku: sku(purchase_order_line_item.sku_id),
          quantity: purchase_order_line_item.quantity,
          before_price: purchase_order_line_item.send(price.type),
          after_price: amount
        )
      end

      def validations
        scope.validate(contents)
        price.validate(contents)
      end

      def purchase_order_lines
        scope.scope(contents)
      end

      def sku(sku_id)
        Sku.find_by(id: sku_id)
      end

      def purchase_order
        PurchaseOrder.where(po_num: contents[0])
      end
    end
  end
end

class CostPrice
  def type
    :cost
  end

  def validate(params)
    errors[:cost_price] = 'not a number' unless params[2].to_s.numeric?
  end
end

class ListPrice
  def type
    :product_rrp
  end

  def validate(params)
    errors[:list_price] = 'not a number' unless params[2].to_s.numeric?
  end
end

class PurchaseOrderScope
  def scope(params)
    PurchaseOrderLineItem.where(po_number: params[0])
  end

  def validate(params)
    errors[:po_lines] = 'po lines do not exist for this po' if scope(params).blank?
  end
end

class ProductScope
  def scope(params)
    PurchaseOrderLineItem.where(po_number: params[0], product_id: params[1])
  end

  def validate(params)
    errors[:product] = 'product does not exist' if Product.find_by(id: params[1]).blank?
    errors[:po_line_item] = 'product does not exist for po' if scope(params).blank?
  end
end

class SkuScope
  def scope(params)
    PurchaseOrderLineItem.where(po_number: params[0], sku_id: params[1])
  end

  def validate(params)
    errors[:sku] = 'sku does not exist' if Sku.find_by(id: params[1]).blank?
    errors[:po_line_item] = 'sku does not exist for po' if scope(params).blank?
  end
end
