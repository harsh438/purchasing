class CreateGoodsReceivedNoticeIssueImages < ActiveRecord::Migration
  def change
    create_table :goods_received_notice_issue_images do |t|
      t.attachment :image
      t.references :goods_received_notice_issue, foreign_key: true, index: {
        name: 'index_grn_issue_images_on_goods_received_notice_issue_id'
      }
    end
  end
end

CreateGoodsReceivedNoticeIssueImages.new.change
