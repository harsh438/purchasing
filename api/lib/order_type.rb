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
    else
      ''
    end
  end

  def self.human_string_from(char)
    string_from(char).split(/(\W)/).map(&:capitalize).join
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
    else
      ''
    end
  end
end
