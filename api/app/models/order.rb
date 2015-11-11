class Order < ActiveRecord::Base
  scope :latest, -> { order(created_at: :desc) }
  paginates_per 50

  has_many :line_items, class_name: 'OrderLineItem'
  accepts_nested_attributes_for :line_items

  has_many :exports, class_name: 'OrderExport'

  def status
    if exports.count > 0
      :exported
    else
      :new
    end
  end

  def new?; status == :new; end
  def exported?; status == :exported; end

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
end
