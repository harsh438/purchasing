class PackingList::Exporter
  def export(attrs)
    if attrs[:type] == 'grn'
      export_grn(attrs)
    elsif attrs[:type] == 'check_sheet'
      export_check_sheet(attrs)
    else
      raise 'PackingList::Exporter#export attrs[:type] not recognised'
    end
  end

  private

  def export_grn(attrs)

    layout = { top_margin: 25,
         bottom_margin: 5,
         left_margin: 5,
         page_size: 'A4',
         page_layout: :landscape }
    grn = GoodsReceivedNotice.includes(:vendors).find(attrs[:id])
    pdf = PackingList::Pdf.new(layout, grn)
    pdf.grn_paper()
    pdf
  end

  def export_check_sheet(attrs)
    layout = { top_margin: 25,
               bottom_margin: 5,
               left_margin: 5,
               page_size: 'A4',
               page_layout: :portrait }
    grn = GoodsReceivedNotice.includes(:purchase_orders).find(attrs[:id])
    pdf = PackingList::Pdf.new(layout, grn)
    purchase_orders = po_lists(grn.purchase_orders)
    pdf.check_sheet(purchase_orders)
    pdf
  end

  def po_lists(purchase_orders)
    po_lists = purchase_orders.map(&:id)
    chuck_pos = PurchaseOrderLineItem.filter_status(status: [:balance])
                                    .where(po_number: po_lists)
                                    .group('purchase_orders.po_number,
                                            purchase_orders.po_chunk_number')
    chuck_pos.map do | chuck_po |
       chuck_string(chuck_po)
    end
  end

  def chuck_string(chuck_po)
    return chuck_po[:po_number] if chuck_po[:po_chunk_number].nil?
     "#{chuck_po[:po_number]}_#{chuck_po[:po_chunk_number]}"
  end
end
