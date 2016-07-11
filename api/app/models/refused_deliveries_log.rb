class RefusedDeliveriesLog < ActiveRecord::Base
  self.table_name = :refused_deliveries_log
  self.primary_key = :id

  include BookingInConnection

  belongs_to :vendor, class_name: 'Vendor', foreign_key: :brand_id

  def as_json_with_vendor_name
    as_json.merge(vendor_name: vendor.try(:name))
  end
end
