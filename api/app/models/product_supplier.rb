class ProductSupplier < ActiveRecord::Base
  include LegacyMappings

  map_attributes product_id: :pid,
                 supplier_id: :supplierID
end
