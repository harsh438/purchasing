class GoodsReceivedNotice::PackingListAttachments < GoodsReceivedNotice::Attachments
  private

  def legacy_field
    goods_received_notice.legacy_attachments
  end

  def packing_lists
    goods_received_notice.packing_lists
  end

  def current_urls
    packing_lists.map(&:list_url).reverse
  end

  def find_attachment_model_by_url(url)
    attachment = GoodsReceivedNotice::Attachment.new(url)
    packing_lists.find_by(list_file_name: attachment.filename)
  end
end
