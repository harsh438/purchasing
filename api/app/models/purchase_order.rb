class PurchaseOrder < ActiveRecord::Base
  # alias_attribute :product_id, :pID #foreign
  # alias_attribute :option_id, :oID #foreign
  # alias_attribute :quantity, :qty
  # # qtyAdded
  # alias_attribute :quantity_done, :qtyDone
  # # status
  # alias_attribute :added_at, :added
  # # order_date
  # # drop_date
  # # arrived_date
  # alias_attribute :invoice_payable_date, :inv_date
  # alias_attribute :summary_id, :po_number #foreign
  # # operator
  # # comment
  # # cost
  # # report_status
  # # cancelled_date
  # # spare2
  # alias_attribute :in_pvx, :inPVX
  # alias_attribute :season, :po_season
  # # reporting_pID
  # # original_pID
  # # original_oID
  # # orderToolLine
  # alias_attribute :report_category_id, :orderTool_RC
  # alias_attribute :lead_gender, :orderTool_LG
  # alias_attribute :vendor_id, :orderTool_venID
  # alias_attribute :line_id, :orderToolItemID
  # alias_attribute :product_name, :orderTool_productName
  # alias_attribute :product_sku, :orderTool_SKU
  # alias_attribute :product_size, :orderTool_SDsize
  # alias_attribute :product_barcode, :orderTool_barcode
  # alias_attribute :sell_price, :orderTool_sellPrice
  # # orderTool_sizeSort
  # # orderTool_MultiLineID
  # # orderTool_SingleLineID
  # alias_attribute :brand_size, :orderTool_brandSize
  # alias_attribute :supplier_list_price, :orderTool_SupplierListPrice
  # alias_attribute :rrp, :orderTool_RRP

  # default_scope -> { select([:id, :product_id, :option_id, :quantity, :quantity_done,
  #                            :status, :added_at, :order_date, :drop_date, :arrived_date,
  #                            :invoice_payable_date, :summary_id, :operator,
  #                            :comment, :cost, :cancelled_date, :in_pvx, :season,
  #                            :report_category_id, :lead_gender, :vendor_id, :line_id,
  #                            :product_name, :product_sku, :product_size, :product_barcode,
  #                            :sell_price, :brand_size, :supplier_list_price, :rrp]) }

  default_scope -> { select('id,
                             pID as product_id,
                             oID as option_id,
                             qty as quantity,
                             qtyDone as quantity_done,
                             added as added_at,
                             inv_date as invoice_payable_date,
                             po_number as summary_id,
                             inPVX as in_pvx,
                             po_season as season,
                             orderTool_RC as report_category_id,
                             orderTool_LG as lead_gender,
                             orderTool_venID as vendor_id,
                             orderToolItemID as line_id,
                             orderTool_productName as product_name,
                             orderTool_SKU as product_sku,
                             orderTool_SDsize as product_size,
                             orderTool_barcode as product_barcode,
                             orderTool_sellPrice as sell_price,
                             orderTool_brandSize as brand_size,
                             orderTool_SupplierListPrice as supplier_list_price,
                             orderTool_RRP as rrp') }
end
