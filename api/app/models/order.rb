class Order < ActiveRecord::Base
  scope :latest, -> { order(created_at: :desc) }
  paginates_per 50

  has_many :line_items, class_name: 'OrderLineItem'
  accepts_nested_attributes_for :line_items

  validates :status, inclusion: { in: %w(new finalized ordered) }

  after_initialize :ensure_status

  def new?; status == 'new'; end
  def finalized?; status == 'finalized'; end
  def ordered?; status == 'ordered'; end

  private

  def ensure_status
    self.status ||= 'new'
  end
end
