class Sku::Generator
  def self.sku_from!(attrs)
    Sku.find_by(manufacturer_sku: attrs[:manufacturer_sku])
  end
end
