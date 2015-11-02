class SupplierVendor < ActiveRecord::Base
  include LegacyMappings

  belongs_to :suppliers, class_name: 'Supplier', foreign_key: :SupplierID
  belongs_to :vendors, class_name: 'Vendor', foreign_key: :BrandID

  self.table_name = 'suppliers_to_brands'
end
