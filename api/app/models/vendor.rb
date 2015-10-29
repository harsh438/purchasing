class Vendor < ActiveRecord::Base
  include LegacyMappings
  self.table_name = :ds_vendors
  map_attributes id: :id,
                 name: :venCompany
end
