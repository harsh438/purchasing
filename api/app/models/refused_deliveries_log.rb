class RefusedDeliveriesLog < ActiveRecord::Base
  self.table_name = :refused_deliveries_log
  self.primary_key = :id

  include BookingInConnection

  belongs_to :refused_delivery_vendor, class_name: 'Vendor', foreign_key: :brand_id
end
