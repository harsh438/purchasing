class PvxIn < ActiveRecord::Base
  self.table_name = :pvx_in

  include LegacyMappings

  map_attributes ds_status:     :DS_status,
                 oa_status:     :OA_status,
                 user_id:       :UserId,
                 delivery_note: :DeliveryNote,
                 po_status:     :PO_status,
                 product_id:    :pid

  belongs_to :product, foreign_key: :pid
end
