class GoodsIn::Normalizer
  INVLAID_PVX_IN_PO_LINE = -11
  READY_TO_RECOCILE = 0
  attr_reader :pvx_in_line, :pvx_in_po_attrs, :sku


  def initialize(pvx_in_line)
    @pvx_in_line = pvx_in_line
    @pvx_in_po_attrs = set_pvx_in_po_attrs
  end

  def process
    return if pvx_in_line.po_status > 0
    if pvx_in_line.po_number.present?
      balance_check
    end
    ActiveRecord::Base.transaction do
      pvx_in_line.update_attributes(pvx_in_attrs)
      PvxInPo.create!(pvx_in_po_attrs)
    end
  end

  private

  def balance_check
    return if pvx_in_line.qty > balance
    pvx_in_po_attrs[:status] = READY_TO_RECOCILE
    pvx_in_po_attrs[:purchase_order_line_id] = purchase_order_line.id
  end

  def purchase_order_line
    @purchase_order_line || PurchaseOrderLineItem.where(po_number: pvx_in_line.po_number,
                                                        sku_id: sku.try(:id)).first
  end

  def balance
    return 0 if sku.nil?
    return 0 if purchase_order_line.nil?
    purchase_order_line.balance_quantity
  end

  def sku
    @sku ||= Sku.by_season(pvx_in_line.sku, season).first
  end

  def season
    @season ||= PurchaseOrderLineItem.season(pvx_in_line.po_number)
  end

  def pvx_in_attrs
    {
      po_status: 1,
      ds_status: 1,
      oa_status: 1
    }
  end

  def set_pvx_in_po_attrs
    {
      sku: pvx_in_line[:sku],
      purchase_order_number: pvx_in_line.po_number,
      qty: pvx_in_line.qty,
      logged: Time.now.utc.to_s(:db),
      status: INVLAID_PVX_IN_PO_LINE,
      delivery_note: pvx_in_line.delivery_note,
      purchase_order_line_id: nil,
      pvx_in_id: pvx_in_line.id
    }
  end
end
