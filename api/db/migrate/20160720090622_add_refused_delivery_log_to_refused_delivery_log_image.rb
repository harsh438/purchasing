class AddRefusedDeliveryLogToRefusedDeliveryLogImage < ActiveRecord::Migration
  def change
  	add_reference :refused_deliveries_log_images, :refused_deliveries_log, index: true
  end
end
