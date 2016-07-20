class RefusedDeliveriesLogImage < ActiveRecord::Base
  belongs_to :refused_deliveries_log
  has_attached_file :image
  do_not_validate_attachment_file_type :image
end
