class SupplierVendor < ActiveRecord::Base
  self.table_name = 'suppliers_to_brands'

  include LegacyMappings

  belongs_to :supplier, foreign_key: :SupplierID
  belongs_to :vendor, foreign_key: :BrandID
end
