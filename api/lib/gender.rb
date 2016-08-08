class Gender
  DISPLAY_MAPPINGS = {
    'M' => ['Men'],
    'W' => ['Women'],
    'U' => ['Men', 'Women'],
    'B' => ['Boy'],
    'G' => ['Girl'],
    'K' => ['Boy', 'Girl'],
    'C' => ['Young Boy'],
    'D' => ['Young Girl'],
    'T' => ['Young Boy', 'Young Girl'],
    'E' => ['Baby Boy'],
    'F' => ['Baby Girl'],
    'I' => ['Baby Boy', 'Baby Girl'],
    'A' => ['All'],
  }.freeze

  STRING_MAPPINGS = {
    'M' => 'Men',
    'W' => 'Women',
    'U' => 'Unisex',
    'B' => 'Boys',
    'G' => 'Girls',
    'K' => 'Kids',
    'T' => 'Toddler',
    'C' => 'Toddler Boy',
    'D' => 'Toddler Girl',
    'I' => 'Infant',
    'E' => 'Infant Boy',
    'F' => 'Infant Girl',
    'P' => 'Promo Item',
    'A' => 'All',
  }.freeze

  REPORTING_GENDER_MAPPINGS = {
    'B' => 'Boy',
    'G' => 'Girl',
    'C' => 'Young Boy',
    'D' => 'Young Girl',
    'E' => 'Baby Boy',
    'F' => 'Baby Girl',
  }.freeze

  attr_reader :char, :name, :display_names, :reporting_name

  def initialize(char)
    @char = char[0].upcase
    @name = STRING_MAPPINGS.fetch(@char)
    @display_names = DISPLAY_MAPPINGS.fetch(@char)
    @reporting_name = REPORTING_GENDER_MAPPINGS.fetch(@char, @name)
  end

  def eql?(obj)
    obj.hash == hash
  end

  def hash
    [Gender, char].hash
  end

  def self.string_from(char)
    STRING_MAPPINGS[char.capitalize]
  end

  def self.char_from(str)
    STRING_MAPPINGS.invert[str]
  end
end
