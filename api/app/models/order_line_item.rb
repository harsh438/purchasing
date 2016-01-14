class OrderLineItem < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  class SkuNotFound < RuntimeError
    attr_reader :sku

    def initialize(sku)
      @sku = sku
    end
  end

  belongs_to :order
  belongs_to :sku
  belongs_to :product

  validates :cost, presence: true
  validates :quantity, presence: true,
                       numericality: { only_integer: true,
                                       greater_than_or_equal_to: 1 }
  validates :discount, allow_blank: true,
                       numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 100 }
  validates :drop_date, presence: true

  after_initialize :ensure_discount_is_at_least_zero

  def internal_sku=(internal_sku)
    super
    find_and_assign_sku
    cache_from_sku
  end

  def as_json(options = {})
    super(options).tap do |line_item|
      line_item[:cost] = number_to_currency(cost, unit: '£')
      line_item[:vendor_name] = vendor_name
      line_item[:drop_date] = drop_date
    end
  end

  def vendor_name
    Vendor.find_by(id: vendor_id).try(:name)
  end

  def discounted_cost
    (cost * ((100 - discount) / 100)).round(2)
  end

  private

  def find_and_assign_sku
    return if sku.present?
    self.sku = Sku.find_by(sku: internal_sku)
  end

  def cache_from_sku
    unless sku.present?
      raise SkuNotFound.new(sku.sku)
    end

    self.product_id = sku.product_id
    self.vendor_id = sku.vendor_id
    self.option_id = sku.option_id || 0
    self.cost = sku.cost_price
    self.season = sku.season
    self.product_name = sku.product_name
    self.gender = sku.gender
    self.reporting_pid = sku.product_id
  end

  def ensure_discount_is_at_least_zero
    self.discount ||= 0
  end
end
