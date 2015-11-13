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

  def vendor=(vendor)
  end

  def as_json(options = {})
    super(options).tap do |line_item|
      line_item[:name] = product.try(:name)
      line_item[:vendor_id] = product.try(:vendor_id)
    end
  end

  def pid
    internal_sku.split('-').first.to_i
  end

  def product
    @product ||= Product.find_by(id: pid)
  end
end
