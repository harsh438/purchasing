module BatchFiles
  module Processors
    class AddMergeJob < BatchFiles::Processors::Base
      HEADERS = %w(season from_internal_sku to_internal_sku barcode).freeze

      validates_presence_of :from_sku, message: 'from_sku does not exist for that season and barcode'
      validates_presence_of :to_sku, message: 'from_sku does not exist for that season and barcode'

      def self.valid_csv(batch_file_contents, errors)
        validate_header(batch_file_contents, errors, *self::HEADERS)
      end

      def self.sample_file
        [
          self::HEADERS,
          %w(AW17 1234-24 1234-55 54321),
          %w(AW17 4321-26 4321-77 12345),
        ]
      end

      def process_method
        ActiveRecord::Base.transaction do
          MergeJob.create!(
            from_sku_id: from_sku.id,
            from_internal_sku: from_sku.sku,
            from_sku_size: from_sku.size,
            to_sku_id: to_sku.id,
            to_internal_sku: to_sku.sku,
            to_sku_size: to_sku.size,
            barcode: barcode
          )
        end
      end

      private

      def from_sku
        Sku.joins(:barcodes).where(season: season, barcodes: { barcode: barcode }, sku: contents[1]).first
      end

      def to_sku
        Sku.joins(:barcodes).where(season: season, barcodes: { barcode: barcode }, sku: contents[2]).first
      end

      def season
        Season.find_by(nickname: contents[0])
      end

      def barcode
        contents[3]
      end
    end
  end
end
