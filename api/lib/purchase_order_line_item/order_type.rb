class PurchaseOrderLineItem::OrderType
  def self.string_from(char)
    case char
      when 'P'
        'Pre-order'
      when 'SR'
        'Suppliers Risk'
      when 'R'
        'Re-order'
      when 'O'
        'Over delivery'
      when 'B'
        'Bulk order'
    end
  end

  def self.char_from(str)
    case str
      when 'Pre-order'
        'P'
      when 'Suppliers Risk'
        'SR'
      when 'Re-order'
        'R'
      when 'Over delivery'
        'O'
      when 'Bulk order'
        'B'
    end
  end
end
