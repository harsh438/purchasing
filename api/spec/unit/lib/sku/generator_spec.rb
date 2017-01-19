RSpec.describe Sku::Generator do
  include_context 'exisiting sized sku that\'s also in in PVX'

  context 'sku to be generated has the same season, barcode and sizing as an existing one' do
    it 'should retrieve the existing sku' do
      sku = subject.generate({ manufacturer_sku: 'mansku-dooby-doo',
                               barcode: existing_sku.barcodes.first.barcode,
                               season: existing_sku.season,
                               inv_track: 'O' })

      %i(sku size color product option language_product_option language_category element).each do |attribute|
        expect(sku.send(attribute)).to be_present
      end
    end
  end

  context 'sku to be generated sku has a different season or barcode or sizing to an existing one' do
    let(:exporter) { instance_double Sku::Exporter }

    subject { described_class.new(exporter).generate(new_sku_attrs) }

    context 'when the season is different' do
      it 'generates a sku and exports it' do
        new_sku_attrs.merge!({ season: 'new_season' })

        expect(exporter).to receive(:export).once
        subject
      end
    end

    context 'when the sizing is different' do
      it 'generates a sku and exports it' do
        new_sku_attrs.merge!({ inv_track: 'P' })

        expect(exporter).to receive(:export).once
        subject
      end
    end

    context 'when the barcode is different' do
      it 'generates a sku and exports it' do
        new_sku_attrs.merge!({ barcode: 'new_barcode' })

        expect(exporter).to receive(:export).once
        subject
      end
    end
  end

  context 'size validation' do
    subject(:generator) { described_class.new }

    context 'same sku, new season, new size' do
      before do
        VCR.use_cassette 'generator_spec_size_validation' do
          new_sku = generator.generate(new_sku_attrs)
          new_sku_attrs[:internal_sku] = new_sku.sku
          new_sku_attrs[:size] = 'medium'
          new_sku_attrs[:season] = 'SS17'
        end
      end

      it 'raises error' do
        expect do
          VCR.use_cassette 'generator_spec_size_validation' do
            generator.generate(new_sku_attrs)
          end
        end.to raise_error ActiveRecord::RecordInvalid

      end
    end
  end
end
