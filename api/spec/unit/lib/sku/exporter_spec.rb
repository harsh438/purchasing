RSpec.describe Sku::Exporter do
  describe 'Existing non sized product being passed in as sized' do
    include_context 'exisiting unsized sku that\'s also in in PVX'

    context 'new sku has the same barcode as existing unsized sku' do
      let!(:new_sku) do
        create(
          :base_sku,
          :sized,
          :with_barcode,
          season: Season.last,
          manufacturer_sku: pvx_sku[:manufacturer_sku],
          barcode: create(:barcode, barcode: barcode.barcode)
        )
      end

      before do
        remove_attrs_that_wont_exist_yet(new_sku)
      end

      subject do
        VCR.use_cassette 'sku_exporter_unsized_prod_as_sized_barcode' do
          described_class.new.export(new_sku)
        end
      end

      it "the new sku's option is not nil" do
        expect(subject.option).to_not be nil
      end

      it "the new sku's element is not nil" do
        expect(subject.element).to_not be nil
      end

      it "the new sku's language_product_option is not nil" do
        expect(subject.language_product_option).to_not be nil
      end

      it 'the new sku is on the same product_id' do
        expect(subject.product).to eq existing_unsized_sku.product
      end

      it 'the new sku has the same barcode' do
        expect(subject.barcodes.map(&:barcode)).to eq existing_unsized_sku.barcodes.map(&:barcode)
      end
    end

    context 'new sku does not have the same barcode; lookup is done by mansku' do
      let!(:new_sku) do
        create(
          :base_sku,
          :sized,
          season: Season.last,
          manufacturer_sku: pvx_sku[:manufacturer_sku]
        )
      end

      subject do
        VCR.use_cassette 'sku_exporter_unsized_prod_as_sized_man_sku' do
          described_class.new.export(new_sku)
        end
      end

      before do
        new_sku.barcodes.create!(
          attributes_for(:barcode)
        )
        remove_attrs_that_wont_exist_yet(new_sku)
      end

      it 'the new product has the same pid as the existing one' do
       expect(subject.product.id).to eq existing_unsized_sku.product.id
      end
    end
  end

  describe 'exporting a sku, that needs a merge, whose barcode exists in pvx, but not in the skus table' do
    let!(:sku) { create(:base_sku, :sized, :with_barcode) }
    let!(:barcode) { create(:barcode, barcode: '700285558479') }
    let!(:product) do
      create(
        :product,
        id: '100010',
        manufacturer_sku: '57-786-',
        barcode: barcode,
        sized: false
      )
    end

    it 'creates a merge job with the data from pvx' do
      VCR.use_cassette 'sku_exporter_unsized_prod_as_sized_barcode' do
        expect { subject.export(sku) }.to change { MergeJob.count }.by(1)
        expect(MergeJob.first.from_sku_id).to eq 0
        expect(MergeJob.first.from_internal_sku).to eq '100010'
        expect(MergeJob.first.completed_at).to be_nil
      end
    end
  end

  def remove_attrs_that_wont_exist_yet(sku)
    sku.option.delete
    sku.element.delete
    sku.language_product_option.delete
    sku.reload
    sku.save!
  end
end
