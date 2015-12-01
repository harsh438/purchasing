class Vendor < ActiveRecord::Base
  self.table_name = :ds_vendors

  include LegacyMappings
  include Searchable

  def self.relevant
    where('venID in (select distinct orderTool_venId from purchase_orders)')
  end

  scope :latest, -> { order(id: :desc) }

  has_many :supplier_vendors, foreign_key: :BrandID, class_name: 'SupplierVendor'
  has_many :suppliers, through: :supplier_vendors

  map_attributes id: :venID,
                 name: :venCompany

  paginates_per 50
end
