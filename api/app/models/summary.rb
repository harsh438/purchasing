class Summary < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  self.table_name = :po_summary

  map_attributes id: :po_num,
                 order_type: :orderType
end
