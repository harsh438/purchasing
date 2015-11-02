class Vendor < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  has_many :supplier_vendors, foreign_key: :BrandID, class_name: 'SupplierVendor'
  has_many :suppliers, through: :supplier_vendors

  self.table_name = :ds_vendors
  
  map_attributes id: :venID,
                 name: :venCompany
end
