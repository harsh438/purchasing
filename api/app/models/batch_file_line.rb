class BatchFileLine < ActiveRecord::Base
  belongs_to :batch_file, foreign_key: :batch_file_id

  belongs_to :batch_file_processor

  serialize :contents
  serialize :processor_errors
  validates :batch_file, presence: true

  scope :ready, -> () { where(status: 'ready') }
  scope :valid, -> () { where(status: 'valid') }
  scope :pending, -> () { where(status: 'pending') }
  # scope :status_eq, -> (status) { where(status: status) if status != 'all' }

  def self.lines_with_headers(batch_file_id)
    joins(:batch_file, batch_file: :batch_file_processor)
      .where(batch_file_id: batch_file_id)
  end

  def process
    processor_type_class.new(self).process
  end

  def validate_line
    processor = processor_type_class.new(self)

    if processor.valid?
      update! status: 'valid'
    else
      update! processor_errors: processor.errors.messages, status: 'invalid'
    end
  end

  def readable_errors(join_with)
    return processor_errors if processor_errors.nil? || processor_errors.empty?
    processor_errors.map do |k, vs|
      vs.map { |v| "#{k}: #{v}".humanize }
    end.join(join_with) if processor_errors
  end

  def invalid?
    status == 'invalid'
  end

  def success?
    status == 'success'
  end

  def failed?
    status == 'failed'
  end

  def as_json_with_headers
    as_json.merge(headers: batch_file.batch_file_processor
                                     .try(:csv_header_row).split(','),
                  description: batch_file.try(:description),
                  processor_type: batch_file.batch_file_processor
                                            .try(:processor_type),
                  batch_file_status: batch_file.try(:status),
                  'processor_errors' => readable_errors('-'))
  end

  private

  delegate :processor_type_class, to: :batch_file
end
