class GoodsReceivedNoticeIssueImage < ActiveRecord::Base
  belongs_to :goods_received_notice_issue
  has_attached_file :image
  do_not_validate_attachment_file_type :image

  def as_json_with_image_url
    as_json.merge(image_url: image.expiring_url(300))
  end
end
