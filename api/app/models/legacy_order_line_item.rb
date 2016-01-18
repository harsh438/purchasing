class LegacyOrderLineItem < ActiveRecord::Base
  self.table_name = 'order_data_details_temp'

  has_many :sizes, class_name: 'LegacyOrderLineItemSize',
                   foreign_key: :OrderID,
                   primary_key: :OrderID
end
