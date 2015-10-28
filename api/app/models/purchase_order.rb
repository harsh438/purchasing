class PurchaseOrder < ActiveRecord::Base
  alias_attribute :product_id, :pID
  alias_attribute :order_id, :oID
  alias_attribute :quantity, :qty
  alias_attribute :quantity_added, :qtyAdded
  alias_attribute :quantity_done, :qtyDone
  # alias_attribute :status, :status # See list from Tony
  alias_attribute :added_at, :added # What does this refer to?
  # alias_attribute :order_date, :order_date
  # alias_attribute :drop_date, :drop_date
  # alias_attribute :arrived_date, :arrived_date
  # alias_attribute :inv_date, :inv_date # What does this refer to?
  # alias_attribute :po_number, :po_number
  # alias_attribute :operator, :operator
  # alias_attribute :comment, :comment
  # alias_attribute :cost, :cost
  # alias_attribute :report_status, :report_status
  # alias_attribute :cancelled_date, :cancelled_date
  alias_attribute :spare_2, :spare2 # What does this refer to?
  alias_attribute :in_pvx, :inPVX # What does this refer to?
  # alias_attribute :po_season, :po_season
  alias_attribute :reporting_pid, :reporting_pID
  alias_attribute :original_product_id, :original_pID # What does this refer to?
  alias_attribute :original_order_id, :original_oID # What does this refer to?
  alias_attribute :order_tool_line, :orderToolLine # What does this refer to?
  alias_attribute :order_tool_rc, :orderTool_RC # What does this refer to?
  alias_attribute :order_tool_lg, :orderTool_LG # What does this refer to?
  alias_attribute :order_tool_ven_id, :orderTool_venID # What does this refer to?
  alias_attribute :order_tool_item_id, :orderToolItemID # What does this refer to?
  alias_attribute :order_tool_product_name, :orderTool_productName # What does this refer to?
  alias_attribute :order_tool_sku, :orderTool_SKU # What does this refer to?
  alias_attribute :order_tool_sd_size, :orderTool_SDsize # What does this refer to?
  alias_attribute :order_tool_barcode, :orderTool_barcode # What does this refer to?
  alias_attribute :order_tool_sell_price, :orderTool_sellPrice # What does this refer to?
  alias_attribute :order_tool_size_sort, :orderTool_sizeSort # What does this refer to?
  alias_attribute :order_tool_multi_line_id, :orderTool_MultiLineID # What does this refer to?
  alias_attribute :order_tool_single_line_id, :orderTool_SingleLineID # What does this refer to?
  alias_attribute :order_tool_brand_size, :orderTool_brandSize # What does this refer to?
  alias_attribute :order_tool_supplier_list_price, :orderTool_SupplierListPrice # What does this refer to?
  alias_attribute :order_tool_rrp, :orderTool_RRP # What does this refer to?
end