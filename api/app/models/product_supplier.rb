class ProductSupplier < ActiveRecord::Base
  include LegacyMappings
  self.table_name = :product_supplier

  map_attributes product_id: :pid,
                 supplier_id: :supplierID
end
