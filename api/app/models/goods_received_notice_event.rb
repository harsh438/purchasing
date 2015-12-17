class GoodsReceivedNoticeEvent < ActiveRecord::Base
  self.table_name = :bookingin_events
  self.primary_key = :ID

  include LegacyMappings

  map_attributes id: :ID

  belongs_to :goods_received_notice, foreign_key: :grn
end
