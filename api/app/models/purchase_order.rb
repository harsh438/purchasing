class PurchaseOrder < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  belongs_to :vendor, foreign_key: :orderTool_venID

  map_attributes id: :id,
                 product_id: :pID,
                 option_id: :oID,
                 quantity: :qty,
                 quantity_added: :qtyAdded,
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

  def product_price
    #nees to come from product table
    0
  end

  def ordered_cost
    quantity * cost
  end

  def ordered_value
    quantity * product_price
  end

  def delivered_quantity
    quantity_done + quantity_added
  end

  def delivered_cost
    delivered_quantity * cost
  end

  def delivered_value
    delivered_quantity * product_price
  end

  def cancelled?
    status == '-1'
  end

  def cancelled_quantity
    if cancelled?
      quantity - delivered_quantity
    end
  end

  def cancelled_cost
    if cancelled?
      cancelled_quantity * cost
    end
  end

  def cancelled_value
    if cancelled?
      cancelled_quantity * product_price
    end
  end

  def balance_quantity
    quantity - delivered_quantity
  end

  def balance_cost
    ordered_cost - delivered_cost
  end

  def balance_value
    ordered_value - delivered_value
  end

  def as_json(*args)
    super.merge(ordered_cost: ordered_cost,
                ordered_value: ordered_value,
                delivered_quantity: delivered_quantity,
                delivered_cost: delivered_cost,
                delivered_value: delivered_value,
                cancelled_quantity: cancelled_quantity,
                cancelled_cost: cancelled_cost,
                cancelled_value: cancelled_value,
                balance_quantity: balance_quantity,
                balance_cost: balance_cost,
                balance_value: balance_value)
  end
end
