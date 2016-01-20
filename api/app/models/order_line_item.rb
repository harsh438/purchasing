class OrderLineItem < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

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

  def ensure_discount_is_at_least_zero
    self.discount ||= 0
  end
end
