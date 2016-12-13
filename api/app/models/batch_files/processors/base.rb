module BatchFiles
  module Processors
    class Base
      include ActiveModel::Model

      def initialize(batch_file_line)
        @batch_file_line = batch_file_line
        @contents = batch_file_line.contents
      end

      def process
        process_method
        batch_file_line.update! status: 'success'
        batch_file_line.batch_file.attempt_send_process_complete_email
      rescue ActiveRecord::RecordInvalid => invalid
        store_exception(invalid, *invalid.record.errors.messages)
      rescue Exception => error
        store_exception(error, error.message)
      end

      def process_method
        raise NotImplementedError
      end

      def self.valid_csv(_batch_file_contents, _errors)
        raise NotImplementedError
      end

      def self.sample_file
        raise NotImplementedError
      end

      private

      def store_exception(exception, *messages)
        batch_file_line.update!(
          status: 'failed',
          processor_errors: { exception.class.name => messages }
        )
      end

      class << self
        private

        def validate_header(batch_file_contents, errors, *columns)
          batch_file_contents[0].try do |h|
            validate_header_length(errors, h, columns.size)
            validate_header_content(errors, h, columns)
          end
        end

        def validate_header_length(errors, header, length)
          count = Array(header).count { |h| h.to_s.strip.present? }
          errors.add(:column_count,
                     "should be at least #{length}") if count < length
        end

        def validate_header_content(errors, header, contents)
          head = downcase_array(header, reject: true)
          cont = downcase_array(contents)
          unless values_present?(cont, head)
            errors.add(:headers, "should be: #{cont.join(', ')}")
          end
        end

        def downcase_array(arr, reject: false)
          results = arr.map { |item| item.to_s.strip.downcase }
          reject ? results.reject(&:blank?) : results
        end

        def values_present?(values, arr)
          values.all? { |value| arr.include?(value) }
        end
      end

      attr_reader :contents
      attr_reader :batch_file_line
    end
  end
end
