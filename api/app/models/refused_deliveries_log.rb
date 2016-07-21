class RefusedDeliveriesLog < ActiveRecord::Base
  self.table_name = :refused_deliveries_log
  self.primary_key = :id

  include BookingInConnection

  belongs_to :vendor, class_name: 'Vendor', foreign_key: :brand_id
  has_many :refused_deliveries_log_images
  accepts_nested_attributes_for :refused_deliveries_log_images


  def as_json_with_vendor_name_and_images
    as_json.merge(vendor_name: vendor.try(:name), images: images)
  end

  def as_json_with_images
    as_json.merge(images: images)
  end

  private

  def images
    refused_deliveries_log_images.map do |delivery_image|
      name = delivery_image.image_file_name
      name = 'Unknown File' if name.blank?
      { url: delivery_image.image.expiring_url(300), name: name }
    end
  end
end
