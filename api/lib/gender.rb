class Gender
  def self.string_from(char)
    case char.capitalize
      when 'M'
        'Men'
      when 'W'
        'Women'
      when 'U'
        'Unisex'
      when 'B'
        'Boys'
      when 'G'
        'Girls'
      when 'K'
        'Kids'
      when 'T'
        'Toddler'
      when 'C'
        'Toddler Boy'
      when 'D'
        'Toddler Girl'
      when 'I'
        'Infant'
      when 'E'
        'Infant Boy'
      when 'F'
        'Infant Girl'
      when 'P'
        'Promo Item'
    end
  end

  def self.char_from(str)
    case str
      when 'Men'
        'M'
      when 'Women'
        'W'
      when 'Unisex'
        'U'
      when 'Boys'
        'B'
      when 'Girls'
        'G'
      when 'Kids'
        'K'
      when 'Toddler'
        'T'
      when 'Toddler Boy'
        'C'
      when 'Toddler Girl'
        'D'
      when 'Infant'
        'I'
      when 'Infant Boy'
        'E'
      when 'Infant Girl'
        'F'
      when 'Promo Item'
        'P'
    end
  end
end
