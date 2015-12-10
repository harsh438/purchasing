class Barcode < ActiveRecord::Base
  belongs_to :sku

  validates :barcode, uniqueness: true
end
