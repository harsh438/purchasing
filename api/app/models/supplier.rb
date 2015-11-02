class Supplier < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  has_many :supplier_vendors, foreign_key: :SupplierID, class_name: 'SupplierVendor'
  has_many :vendors, through: :supplier_vendors

  self.table_name = :suppliers
  map_attributes id: :SupplierID,
                 name: :SupplierName
end
