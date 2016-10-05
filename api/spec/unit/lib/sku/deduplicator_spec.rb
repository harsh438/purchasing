RSpec.describe Sku::Deduplicator do

  let(:sku_1) { Sku.new(
    sku: '12345-67',
    season: Season.first,
    manufacturer_sku: 'ABC1234',
    price: 12.85,
    cost_price: 5.92,
    manufacturer_size: 'S',
    size: 's',
  ) }

  let(:sku_2) { Sku.new(
    sku: '12345-67',
    season: Season.first,
    manufacturer_sku: 'ABC1234',
    price: 12.85,
    cost_price: 5.92,
    manufacturer_size: 'S',
    size: 's',
  ) }

  let(:sku_3) { Sku.new(
    sku: '12345-68',
    season: Season.first,
    manufacturer_sku: 'ABC1235',
    price: 13.90,
    cost_price: 5.92,
    manufacturer_size: 'L',
    size: 'l',
  ) }

  let(:sku_4) { Sku.new(
    sku: '12345-68',
    season: Season.last,
    manufacturer_sku: 'ABC1235',
    price: 13.90,
    cost_price: 5.92,
    manufacturer_size: 'L',
    size: 'l',
  ) }

  let(:deduper) { described_class.new }

  subject(:results) { deduper.without_duplicates(sku_1, sku_2, sku_3) }

  describe '#without_duplicates' do

    it 'returns an array of sku attribute hashes' do
      expect(results).to match [
        a_hash_including(sku: sku_1.sku),
        a_hash_including(sku: sku_3.sku),
      ]
    end

    it 'has the necessary attributes' do
      expect(results.first).to include(
        sku: sku_1.sku,
        price: sku_1.price,
        cost_price: sku_1.cost_price,
        legacy_brand_size: sku_1.manufacturer_size,
        options: {
          size: sku_1.size,
        }
      )
    end

    context 'with different seasons' do

      before { sku_2.season = Season.last }

      it 'the duplicate sku is not considered a duplicate' do
        expect(results).to match [
          a_hash_including(sku: sku_1.sku),
          a_hash_including(sku: sku_2.sku),
          a_hash_including(sku: sku_3.sku),
        ]
      end

    end

    context 'when duplicated skus have identical barcodes' do

      let(:barcode_1) { 'ABC12324' }
      let(:barcode_2) { 'XYZ1234' }

      before do
        [sku_1, sku_2, sku_3, sku_4].each(&:save!)
        sku_1.barcodes.create!(barcode: barcode_1)
        sku_2.barcodes.create!(barcode: barcode_1)
        sku_3.barcodes.create!(barcode: barcode_2)
        sku_4.barcodes.create!(barcode: barcode_2)
      end

      subject(:results) { deduper.without_duplicates(sku_1, sku_2, sku_3, sku_4) }

      it 'returns the associated barcode' do
        # note that sku_4 is a different season and thus not a duplicate
        expect(results).to match [
          a_hash_including(sku: sku_1.sku, barcode: barcode_1),
          a_hash_including(sku: sku_3.sku, barcode: barcode_2),
          a_hash_including(sku: sku_4.sku, barcode: barcode_2),
        ]
      end

    end

    context 'when duplicated skus have different barcodes' do

      let(:barcode_1) { 'ABC12324' }
      let(:barcode_2) { 'DEF12324' }
      let(:barcode_3) { 'XYZ1234' }
      let(:barcode_4) { 'DAZ1234' }

      before do
        [sku_1, sku_2, sku_3, sku_4].each(&:save!)
        sku_1.barcodes.create!(barcode: barcode_1)
        sku_2.barcodes.create!(barcode: barcode_2)
        sku_3.barcodes.create!(barcode: barcode_3)
        sku_4.barcodes.create!(barcode: barcode_4)
      end

      subject(:results) { deduper.without_duplicates(sku_1, sku_2, sku_3, sku_4) }

      it 'returns the latest associated barcode' do
        expect(results).to match [
          a_hash_including(barcode: barcode_2),
          a_hash_including(barcode: barcode_3),
          a_hash_including(barcode: barcode_4),
        ]
      end
    end
  end
end
