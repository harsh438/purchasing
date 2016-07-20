class CreateRefusedDeliveriesLogImages < ActiveRecord::Migration
  def change
    create_table :refused_deliveries_log_images do |t|
      t.attachment :image

      t.timestamps null: false
    end
  end
end
