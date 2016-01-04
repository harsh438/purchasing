class OrderType
  def self.string_from(char)
    case char.capitalize
      when 'P'
        'preorder'
      when 'SR'
        'suppliers_risk'
      when 'R'
        'reorder'
      when 'O'
        'over_delivery'
      when 'B'
        'bulk_order'
    end
  end

  def self.char_from(str)
    case str.downcase
      when 'preorder'
        'P'
      when 'suppliers_risk'
        'SR'
      when 'reorder'
        'R'
      when 'over_delivery'
        'O'
      when 'bulk_order'
        'B'
    end
  end
end
