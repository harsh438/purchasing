class Vendor < ActiveRecord::Base
  include LegacyMappings
  self.table_name = :ds_vendors
  map_attributes id: :id,
                 venCompany: :name
end
