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

  def internal_sku=(internal_sku)
    super
    cache_product
  end

  def cache_product
    self.product_id = build_pid
    self.product_name = product.try(:name)
    self.vendor_id = product.try(:vendor_id)
    self.option_id = ProductOption.id_from_element(build_element_id)
    self.cost = product.try(:price)
  end

  def as_json(options = {})
    super(options).tap do |line_item|
      line_item[:name] = product.try(:name)
      line_item[:cost] = number_to_currency(cost, unit: '£')
      line_item[:vendor_id] = vendor_id
      line_item[:vendor_name] = vendor_name
    end
  end

  def vendor_name
    Vendor.find_by(id: vendor_id).try(:name)
  end

  def discounted_cost
    (cost * ((100 - discount) / 100)).round(2)
  end

  def product
    @product ||= Product.find_by(id: build_pid)
  end

  private

  def build_pid
    internal_sku.split('-').first.to_i
  end

  def build_element_id
    internal_sku.split('-').second.to_i
  end
end
