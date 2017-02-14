class PurchaseOrderTransactionLog < ActiveRecord::Base
  self.table_name = :sd_po_tran

  include LegacyMappings

  map_attributes po_line_number:    :lineNumber,
                 product_id:        :pid,
                 option_id:         :oid,
                 sku:               :OASKU,
                 balance:           :Balance,
                 web_inv:           :webInv,
                 pushthrough_date:  :pushthrough,
                 quantity:          :qty,
                 input_type:        :type,
                 purchase_order:    :po_number,
                 checked_date:      :checked
end
