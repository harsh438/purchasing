class OrderType
  def self.string_from(char)
    case char.capitalize
      when 'R'
        'reorder'
      when 'P'
        'preorder'
    end
  end

  def self.char_from(str)
    case str
      when 'reorder'
        'R'
      when 'preorder'
        'P'
    end
  end
end
