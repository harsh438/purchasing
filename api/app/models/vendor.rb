class Vendor < ActiveRecord::Base
  self.table_name = :ds_vendors

  include LegacyMappings
  include Searchable

  has_many :supplier_vendors, foreign_key: :BrandID, class_name: 'SupplierVendor'
  has_many :suppliers, through: :supplier_vendors

  map_attributes id: :venID,
                 name: :venCompany

  def self.relevant
     where('venID in (select distinct orderTool_venId from purchase_orders)')
  end
end
