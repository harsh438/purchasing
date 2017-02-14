class BatchFile < ActiveRecord::Base
  include GeneralCsvValidator

  has_many :batch_file_lines, dependent: :destroy
  belongs_to :batch_file_processor,
             class_name: 'BatchFileProcessor',
             foreign_key: :processor_type_id
  belongs_to :user, class_name: 'User', foreign_key: :created_by_id

  serialize :csv_header_row


  before_create :set_csv_header_row
  after_create :create_file_lines

  has_attached_file :csv

  validates :contents, presence: true
  validates :processor_type_id, presence: true
  validate :validate_csv
  validates_attachment_content_type :csv, { content_type: 'text/csv' }
  validates_attachment_size :csv, in: 0.megabytes..2.megabytes

  attr_accessor :contents, :csv_header_row

  def self.available_processors
    [
      BatchFiles::Processors::UpdatePurchaseOrderCostPriceBySku,
      BatchFiles::Processors::UpdatePurchaseOrderProductRRPBySku,
      BatchFiles::Processors::UpdatePurchaseOrderCostPriceByPid,
      BatchFiles::Processors::UpdatePurchaseOrderListPriceByPid,
      BatchFiles::Processors::UpdatePurchaseOrderSupplierCostPrice,
      BatchFiles::Processors::UpdatePurchaseOrderCostPriceByPercent,
      BatchFiles::Processors::AddMergeJob
    ].sort { |a, b| a.to_s <=> b.to_s }
  end

  def self.with_processor
    joins(:batch_file_processor)
  end

  def self.with_status(id)
    where(id: id).map(&:as_json_with_status_name)
  end

  def process!
    return false unless processable?

    batch_file_lines.valid.pluck(:id).each do |line_id|
      BatchFileLineProcessWorker.perform_async(line_id)
    end

    update_columns processing_started: true
  end

  def validate!
    return false unless validatable?

    batch_file_lines.pending.pluck(:id).each do |line_id|
      BatchFileLineValidateWorker.perform_async(line_id)
    end

    update_columns validation_started: true
  end

  def processor_type_class
    batch_file_processor.processor_type.constantize
  end

  def validatable?
    !validation_started
  end

  def validating?
    validation_started && (batch_file_lines.none? || statuses.include?('pending'))
  end

  def fully_validated?
    !validating? && processable?
  end

  def fully_processed?
    batch_file_lines.any? &&
    (statuses & ['success', 'failed']).any?
  end

  def processable?
    validation_started &&
    !validating? &&
    !processing_started &&
    batch_file_lines.any? &&
    (statuses & ['valid']).any? &&
    !fully_processed?
  end

  def processing?
    processing_started && (statuses & ['valid']).any?
  end

  def status
    # only used for indication on template
    return 'new'              if validatable?
    return 'validating'       if validating?
    return 'ready to process' if processable?
    return 'processing'       if processing?
    return 'fully processed'  if fully_processed?
    'not processable'
  end

  def statuses
    @statuses ||= batch_file_lines.pluck(:status).uniq
  end

  def csv_header_first_column
    @csv_header_row.first
  end

  def attempt_send_process_validate_email
    BatchFileMailer.validating_complete(self).deliver_now if fully_validated?
  end

  def attempt_send_process_complete_email
    BatchFileMailer.processing_complete(self).deliver_now if fully_processed?
  end

  private

  def set_csv_header_row
    @csv_header_row = contents.first
  end

  def create_file_lines
    # skips the csv first column (headers)
    contents[1..-1].each_slice(1000) do |lines|
      values = lines.map { |l| [id, l, 'pending'] }
      BatchFileLine.import [:batch_file_id, :contents, :status], values
    end
  end

  def validate_csv
    return false if !contents
    basic_valid_csv(contents, errors)
    processor_type_class.valid_csv(contents, errors)
  end

  def validate_contents_header(id, header)
    BatchFileProcessor.find_by!(id: id).csv_header_row == header.join(',')
  end
end
