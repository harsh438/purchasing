class PurchaseOrder < ActiveRecord::Base
  self.table_name = :po_summary
  self.primary_key = :po_num

  include LegacyMappings
  include Searchable
  include ActiveModel::Serialization

  map_attributes id: :po_num,
                 order_type: :orderType,
                 vendor_id: :venID,
                 vendor_name: :Brand

  has_paper_trail on: [:create, :update, :destroy],
                  ignore: [:updated_at, :created_at]

  has_many :line_items, class_name: 'PurchaseOrderLineItem',
                        foreign_key: :po_number

  has_many :order_exports
  has_many :orders, through: :order_exports
  has_many :goods_received_notice_events, foreign_key: :po

  belongs_to :vendor, foreign_key: :venID

  after_initialize :ensure_defaults
  after_initialize :set_legacy

  def serialize_by_line_item_chunks(chunk_size)
    chunks = []
    current_po_num = 1
    PurchaseOrder.no_touching do
      ActiveRecord::Base.transaction do
        line_items.by_chunks(chunk_size) do |items_chunk|
          update_line_item_chunk_number(items_chunk, current_po_num)
          chunks.push(items_chunk)
          current_po_num += 1
        end
      end
    end
    serialize_line_items_chunks(chunks)
  end

  def self.has_been_updated_since(timestamp, max_id = 0)
    if timestamp.nil?
      where('po_summary.updated_at is null and po_summary.po_num > ?', max_id)
    else
      where('(po_summary.updated_at = ? and po_summary.po_num > ?) or (po_summary.updated_at > ?)', timestamp, max_id, timestamp)
    end
  end

  def self.without_negative_pids
    joins(:line_items).where('purchase_orders.pID > 0')
  end

  def self.from_yesterday
    where('po_date > ?', Date.yesterday)
  end

  def self.not_sent_in_peoplevox
    includes(:line_items).where(purchase_orders: { inPVX: 0 })
  end

  def self.bookable
    includes(line_items: { sku: :barcodes })
      .includes_line_items
      .without_negative_pids
      .to_a
      .keep_if(&:bookable?)
  end

  def self.booked_in
    joins(:goods_received_notice_events)
      .where.not({ bookingin_events: { id: nil } })
      .bookable
  end

  def self.includes_line_items
    includes(:line_items, line_items: [:vendor, :sku, :product, :purchase_order])
  end

  def po_number
    id
  end

  def quantity
    line_items.map(&:quantity).sum
  end

  def total
    line_items.map(&:total).sum
  end

  def bookable?
    balance_line_items = line_items.filter_status(status: [:balance])
    return false if balance_line_items.empty?
    !balance_line_items.any?(&:barcodeless?)
  end

  def as_json_with_line_items
    as_json.merge(purchase_order_line_items: line_items.as_json)
  end

  private

  def update_line_item_chunk_number(items_chunk, po_chunk_number)
    items_chunk.each do |item|
      item.po_chunk_number = po_chunk_number
      item.save!
    end
  end

  def serialize_line_items_chunks(line_item_chunks)
    start_id = 1
    line_item_chunks.map do |chunk|
      serialized_chunks = PurchaseOrderChunkSerializer.serialize(self,
                                                                 chunk,
                                                                 start_id)
      start_id += chunk.size
      serialized_chunks
    end
  end

  def ensure_defaults
    self.po_date ||= Time.now
  end

  def set_legacy
    self.orderGrouping = ''
  end
end
