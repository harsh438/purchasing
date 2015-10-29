class PurchaseOrder < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  belongs_to :vendor, foreign_key: :orderTool_venID

  map_attributes id: :id,
                 product_id: :pID,
                 option_id: :oID,
                 quantity: :qty,
                 quantity_done: :qtyDone,
                 status: :status,
                 created_at: :added,
                 order_date: :order_date,
                 drop_date: :drop_date,
                 arrived_date: :arrived_date,
                 invoice_payable_date: :inv_date,
                 summary_id: :po_number,
                 operator: :operator,
                 comment: :comment,
                 cost: :cost,
                 cancelled_date: :cancelled_date,
                 in_pvx: :inPVX,
                 season: :po_season,
                 report_category_id: :orderTool_RC,
                 lead_gender: :orderTool_LG,
                 vendor_id: :orderTool_venID,
                 line_id: :orderToolItemID,
                 product_name: :orderTool_productName,
                 product_sku: :orderTool_SKU,
                 product_size: :orderTool_SDsize,
                 product_barcode: :orderTool_barcode,
                 sell_price: :orderTool_sellPrice,
                 brand_size: :orderTool_brandSize,
                 supplier_list_price: :orderTool_SupplierListPrice,
                 rrp: :orderTool_RRP,

                 # Unused but necessary for insertion
                 reporting_product_id: :reporting_pID,
                 original_product_id: :original_pID,
                 original_option_id: :original_oID

  filters :vendor_id,
          :lead_gender

  paginates_per 50
end
