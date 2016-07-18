class Barcode < ActiveRecord::Base
  belongs_to :sku, touch: true
  validates :barcode, presence: true

  before_validation :strip_whitespace

  scope :latest, -> { order(created_at: :desc).first }

  private

  def strip_whitespace
    self.barcode = barcode.strip if barcode.present?
  end
end
