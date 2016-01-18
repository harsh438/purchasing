class LegacyOrderLineItemSize < ActiveRecord::Base
  self.table_name = 'sizemapper_to_orders'

  belongs_to :order, inverse_of: :sizes

  def manufacturer_size
    attributes['BrandEquivalentSize']
  end

  def size
    attributes['SurfdomeSize']
  end

  def cost_price
    attributes['SurfdomeSize']
  end

  def list_price
    attributes['SurfdomeSize']
  end

  def price
    attributes['SurfdomeSize']
  end
end
