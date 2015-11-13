class OrderLineItem < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :order

  validates :internal_sku, presence: true
  validates :cost, presence: true
  validates :quantity, presence: true
  validates :discount, allow_blank: true,
                       numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 100 }
  validates :drop_date, presence: true

  attr_accessor :vendor

  def as_json(options = {})
    super(options).tap do |line_item|
      line_item[:name] = product.try(:name)
      line_item[:vendor_id] = vendor_id
      line_item[:discount] = number_to_currency(discount, unit: '£')
      line_item[:product_cost] = number_to_currency(product_cost, unit: '£')
    end
  end

  def vendor_id
    product.try(:vendor_id)
  end

  def product_cost
    product.try(:price)
  end

  def pid
    internal_sku.split('-').first.to_i
  end

  def product
    @product ||= Product.find_by(id: pid)
  end

  def discounted_cost
    (cost * ((100 - discount) / 100)).round(2)
  end
end
