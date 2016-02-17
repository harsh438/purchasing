class PackingList < ActiveRecord::Base
  belongs_to :goods_received_notice
  
  has_attached_file :list
  do_not_validate_attachment_file_type :list

  def list_url
    list.expiring_url(300)
  end
end
