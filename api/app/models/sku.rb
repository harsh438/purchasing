class Sku < ActiveRecord::Base
  paginates_per 50

  belongs_to :product
  belongs_to :element
  belongs_to :product_option

  validates_presence_of :element_id
  validates_presence_of :manufacturer_sku
  validates_presence_of :product_id
  validates_presence_of :option_id
  validates_presence_of :season
  validates_presence_of :sku

  def self.generate_from!(attrs)
    Sku.create(generate_attrs_from(attrs))
  end

  private

  def self.generate_attrs_from(attrs)
    attrs.merge!({ sku: "#{attrs[:product_id]}-#{attrs[:element_id]}",
                   option_id: ProductOption.id_from_element(attrs[:product_id], attrs[:element_id]) })
  end
end
