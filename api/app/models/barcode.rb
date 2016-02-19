class Barcode < ActiveRecord::Base
  belongs_to :sku
  validates :barcode, presence: true

  before_validation :strip_whitespace

  private

  def strip_whitespace
    self.barcode = barcode.strip if barcode.present?
  end
end
