class Vendor < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  self.table_name = :ds_vendors
  map_attributes id: :venID,
                 name: :venCompany
end
