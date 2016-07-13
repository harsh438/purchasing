class Barcode < ActiveRecord::Base
  belongs_to :sku, touch: true
  validates :barcode, presence: true, format: { without: /['"]/i }

  before_validation :strip_whitespace

  private

  def strip_whitespace
    self.barcode = barcode.strip if barcode.present?
  end
end
