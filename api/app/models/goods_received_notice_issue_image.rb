class GoodsReceivedNoticeIssueImage < ActiveRecord::Base
  belongs_to :goods_received_notice_issue
  has_attached_file :image
  do_not_validate_attachment_file_type :image
  after_create :refresh_issue_attachments
  after_destroy :refresh_issue_attachments

  private

  def refresh_issue_attachments
    goods_received_notice_issue.refresh_attachments
  end
end
