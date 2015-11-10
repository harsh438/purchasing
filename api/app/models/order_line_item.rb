class OrderLineItem < ActiveRecord::Base
  belongs_to :order

  validates :internal_sku, presence: true
  validates :cost, presence: true
  validates :quantity, presence: true
  validates :discount, numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 100 }
end
