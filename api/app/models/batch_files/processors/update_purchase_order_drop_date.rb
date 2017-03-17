module BatchFiles
  module Processors
    class UpdatePurchaseOrderDropDate < BatchFiles::Processors::Base
      HEADERS         = %w(po dropdate).freeze
      PO_STATUS_ERROR = 'po status is not ready to receive. Some or all of the po'\
                        'may have been dropped already'.freeze
      DD_FORMAT_ERROR = 'drop date is not a valid date format use DD/MM/YYYY'.freeze
      DD_DATE_ERROR   = 'The date selected is before now.'\
                        'You can\'t choose a drop date from the past'.freeze

      validates_presence_of :purchase_order, message: 'purchase order does not exist!'
      validate :drop_date_format
      validate :po_status

      def self.valid_csv(batch_file_contents, errors)
        validate_header(batch_file_contents, errors, *self::HEADERS)
      end

      def process_method
        ActiveRecord::Base.transaction do
          purchase_order.update_attributes(drop_date: formatted_drop_date)
          po_lines.each do |line|
            line.update_attributes(drop_date: formatted_drop_date)
          end
        end
      end

      def self.sample_file
        [
          self::HEADERS,
          %w(123 10/10/2020),
          %w(456 12/12/2018),
        ]
      end

      private

      def formatted_drop_date
        DateTime.parse(drop_date_string).to_s(:db)
      end

      def drop_date_string
        contents[1]
      end

      def purchase_order
        @purchase_order ||= PurchaseOrder.find_by(id: contents[0])
      end

      def po_lines
        @po_lines ||= PurchaseOrderLineItem.where(po_number: contents[0])
      end

      def drop_date_format
        begin
          if Time.current.utc > DateTime.parse(drop_date_string)
            errors[:drop_date] = DD_DATE_ERROR
          end
        rescue ArgumentError
          return errors[:drop_date] = DD_FORMAT_ERROR
        end
      end

      def po_status
        if po_lines.map(&:status).uniq.sort != ([:new_po] || [:cancelled] || [:cancelled, :new_po])
          errors[:purchase_order] = PO_STATUS_ERROR
        end
      end
    end
  end
end
