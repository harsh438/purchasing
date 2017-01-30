class PurchaseOrder::Reconciler
  PURCHASE_ORDER_LINE_WITH_BALANCE = 4
  COMPLETED_PURCHASE_ORDER_LINE = 5
  COMPLETED_PVX_IN_PO = 1

  attr_reader :attrs, :purchase_order_line

  def initialize(attrs)
    @attrs = attrs
    @purchase_order_line = purchase_order_line_item
  end

  def reconcile
    return if purchase_order_line.blank?
    ActiveRecord::Base.transaction do
      pvx_in_po_attrs = set_pvx_in_po_attrs
      if balance >= 0
        transaction_log
        purchase_order_line.update_attributes(received_stock)
        pvx_in_po_attrs = set_pvx_in_po_attrs(COMPLETED_PVX_IN_PO,
                                            attrs.purchase_order_line_id,
                                            attrs.purchase_order_number)
      end
      update_pvx_in_po(pvx_in_po_attrs)
    end
  end

  private

  def purchase_order_line_item
    begin
      PurchaseOrderLineItem.find(attrs[:po_line])
    rescue ActiveRecord::RecordNotFound
      po_line_attrs = set_pvx_in_po_attrs
      update_pvx_in_po(po_line_attrs)
      return nil
    end
  end

  def received_stock
    {
      quantity_done: quantity_done,
      arrived_date: logged_date,
      invoice_payable_date: logged_date,
      status: purchase_order_status
    }
  end

  def balance
    @balance ||= purchase_order_line.balance_quantity - attrs.qty
  end

  def purchase_order_status
    balance == 0 ? COMPLETED_PURCHASE_ORDER_LINE : PURCHASE_ORDER_LINE_WITH_BALANCE
  end

  def logged_date
    @logged_date ||= Date.parse(attrs[:logged].to_s).strftime('%Y-%m-%d')
  end

  def quantity_done
    purchase_order_line.quantity_done + attrs.qty
  end

  def transaction_log
    {
      po_line_number: purchase_order_line[:id],
      product_id: sku.try(:product_id),
      option_id: sku.try(:option_id),
      sku: attrs[:sku],
      balance: balance,
      web_inv: 0,
      pushthrough_date: logged_date,
      quantity: attrs[:qty],
      type: 'LOPVX',
      arrived_date: logged_date,
      invoice_date: logged_date,
      logged: Time.now.utc.to_s(:db)
    }
  end

  def sku
    @sku ||= Sku.find(purchase_order_line[:sku_id])
  end

  def set_pvx_in_po_attrs(status = GoodsIn::Normalizer::INVLAID_PVX_IN_PO_LINE,
                          po_line = nil, po_number = nil)
    {
      id: attrs[:id],
      status: status,
      purchase_order_line_id: po_line,
      purchase_order_number: po_number
    }
  end

  def update_pvx_in_po(po_line_attrs)
    PvxInPo.find(attrs[:id]).update_attributes(po_line_attrs)
  end
end
