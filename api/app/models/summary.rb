class Summary < ActiveRecord::Base
  self.table_name = :po_summary

  include LegacyMappings
  include Searchable

  map_attributes id: :po_num,
                 order_type: :orderType
end
