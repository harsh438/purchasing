class Supplier < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  has_many :supplier_vendors, foreign_key: :SupplierID, class_name: 'SupplierVendor'
  has_many :vendors, through: :supplier_vendors

  self.table_name = :suppliers

  map_attributes id: :SupplierID,
                 name: :SupplierName

  def self.relevant
    joins('inner join suppliers_to_brands sb on suppliers.SupplierID = sb.SupplierID')
      .where('sb.BrandID in (select distinct orderTool_venId from purchase_orders)')
      .uniq
  end

  def self.alphabetical
    order(name: :asc)
  end
end
