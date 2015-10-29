class PurchaseOrder < ActiveRecord::Base
  include LegacyMappings
  belongs_to :vendor, foreign_key: :orderTool_venID

  map_attributes id: :id,
                 pID: :product_id,
                 oID: :option_id,
                 qty: :quantity,
                 qtyDone: :quantity_done,
                 status: :status,
                 added: :created_at,
                 order_date: :order_date,
                 drop_date: :drop_date,
                 arrived_date: :arrived_date,
                 inv_date: :invoice_payable_date,
                 po_number: :summary_id,
                 operator: :operator,
                 comment: :comment,
                 cost: :cost,
                 cancelled_date: :cancelled_date,
                 inPVX: :in_pvx,
                 po_season: :season,
                 orderTool_RC: :report_category_id,
                 orderTool_LG: :lead_gender,
                 orderTool_venID: :vendor_id,
                 orderToolItemID: :line_id,
                 orderTool_productName: :product_name,
                 orderTool_SKU: :product_sku,
                 orderTool_SDsize: :product_size,
                 orderTool_barcode: :product_barcode,
                 orderTool_sellPrice: :sell_price,
                 orderTool_brandSize: :brand_size,
                 orderTool_SupplierListPrice: :supplier_list_price,
                 orderTool_RRP: :rrp,

                 # Unused but necessary for insertion
                 reporting_pID: :reporting_product_id,
                 original_pID: :original_product_id,
                 original_oID: :original_option_id

  paginates_per 50
end
