class Order < ActiveRecord::Base
  after_initialize :ensure_status

  validates :status, inclusion: { in: %w(new finalized ordered) }

  def new?; status == 'new'; end
  def finalized?; status == 'finalized'; end
  def ordered?; status == 'ordered'; end

  private

  def ensure_status
    self.status ||= 'new'
  end
end
