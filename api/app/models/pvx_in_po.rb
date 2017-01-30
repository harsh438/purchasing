class PvxInPo < ActiveRecord::Base
  self.table_name = :pvx_in_po
  include LegacyMappings

  map_attributes purchase_order_number:  :ponum,
                 purchase_order_line_id: :po_line,
                 delivery_note: :DeliveryNote,
                 pvx_in_id: :pvx_in_ref
end
