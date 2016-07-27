class GoodsReceivedNoticeIssue < ActiveRecord::Base
  self.table_name = :issues_to_grn

  ISSUE_TYPE_MAPPING = {
    cartons_good_condition: 3
  }

  include BookingInConnection
  include LegacyMappings

  map_attributes id: :id,
                 goods_received_notice_id: :grn,
                 issue_type_id: :IssueTypeID,
                 sku_list: :SkuList,
                 pid_list: :PidList,
                 comments: :Comments,
                 units_affected: :Units,
                 time_taken_to_resolve: :TimeToResolve,
                 attachments: :Attachments

  belongs_to :goods_received_notice
  has_many :goods_received_notice_issue_images

  accepts_nested_attributes_for :goods_received_notice_issue_images

  after_initialize :ensure_defaults

  def issue_type=(issue_type_name)
    self.issue_type_id = ISSUE_TYPE_MAPPING[issue_type_name.to_sym]
  end

  def refresh_attachments
    if goods_received_notice_issue_images.any?
      filenames = goods_received_notice_issue_images.pluck(:image_file_name)
      update(attachments: ",#{filenames.join(',')}")
    else
      update(attachments: nil)
    end
  end

  private

  def ensure_defaults
    self.units_affected ||= 0
    self.time_taken_to_resolve ||= 0
  end
end
