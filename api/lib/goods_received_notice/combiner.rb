class GoodsReceivedNotice::Combiner
  def combine(attrs)
    GoodsReceivedNotice.transaction do
      GoodsReceivedNoticeEvent.transaction do
        update_grn_events_grn(attrs[:from], attrs[:to])
        copy_packing_lists_to_grn(attrs[:from], attrs[:to])
        delete_grn(attrs[:from])
      end
    end
  end

  private

  def update_grn_events_grn(from_grn, to_grn)
    from_grn.goods_received_notice_events.update_all(grn: to_grn)
  end

  def copy_packing_lists_to_grn(from_grn, to_grn)
    to_grn.legacy_attachments << from_grn.legacy_attachments
    to_grn.save!
    to_grn.packing_lists.<<(*from_grn.packing_lists)
  end

  def delete_grn(from_grn)
    from_grn.destroy
  end
end
