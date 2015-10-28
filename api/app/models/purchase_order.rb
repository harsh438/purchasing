class PurchaseOrder < ActiveRecord::Base
  alias_attribute :product_id, :pID
  alias_attribute :order_id, :oID
  alias_attribute :quantity, :qty
  alias_attribute :quantity_done, :qtyDone
  alias_attribute :added_at, :added
  alias_attribute :invoice_payable_date, :inv_date
  alias_attribute :summary_id, :po_number
  alias_attribute :in_pvx, :inPVX
  alias_attribute :order_tool_rc, :orderTool_RC
  alias_attribute :order_tool_lg, :orderTool_LG
  alias_attribute :order_tool_ven_id, :orderTool_venID
  alias_attribute :order_tool_item_id, :orderToolItemID
  alias_attribute :order_tool_product_name, :orderTool_productName
  alias_attribute :order_tool_sku, :orderTool_SKU
  alias_attribute :order_tool_sd_size, :orderTool_SDsize
  alias_attribute :order_tool_barcode, :orderTool_barcode
  alias_attribute :order_tool_sell_price, :orderTool_sellPrice
  alias_attribute :order_tool_brand_size, :orderTool_brandSize
  alias_attribute :order_tool_supplier_list_price, :orderTool_SupplierListPrice
  alias_attribute :order_tool_rrp, :orderTool_RRP
end
