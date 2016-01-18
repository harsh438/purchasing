class Barcode < ActiveRecord::Base
  belongs_to :sku
  validates :barcode, presence: true
end
