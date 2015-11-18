class Order < ActiveRecord::Base
  scope :latest, -> { order(created_at: :desc) }
  paginates_per 50

  has_many :line_items, class_name: 'OrderLineItem'
  accepts_nested_attributes_for :line_items

  has_many :exports, class_name: 'OrderExport'
  has_many :purchase_orders, through: :exports

  after_initialize :ensure_name

  def status
    if exports.size > 0
      :exported
    else
      :new
    end
  end

  def new?; status == :new; end
  def exported?; status == :exported; end

  def as_json_with_line_items_and_purchase_orders(options = {})
    as_json(options).tap do |order|
      order[:line_items] = line_items.order(created_at: :desc).map { |line| line.as_json }
      order[:purchase_orders] = purchase_orders { |po| po.as_json }
    end
  end

  def as_json(options = {})
    super.tap do |order|
      order[:created_at] = created_at.to_s
      order[:updated_at] = updated_at.to_s
      order[:status] = status
      order[:exported] = exported?

      if exported?
        order[:exported_at] = exports.first.created_at.to_s
      else
        order[:exported_at] = nil
      end
    end
  end

  private

  def ensure_name
    self.name ||= "Export ##{id || (self.class.maximum(:id) || 0).next}"
  end
end
