require 'spec_helper'

RSpec.describe Sku::Exporter do
  describe 'Existing non sized product being passed in as sized' do
    let!(:product) { create(:product) }
    let!(:season) { create(:season, nickname: 'SS20', name: 'SS') }
    let!(:existing_unsized_sku) { create(:base_sku, :with_product, product: product) }

    before do
      existing_unsized_sku.product.update_attributes(
        manufacturer_sku: existing_unsized_sku.manufacturer_sku
      )
      existing_unsized_sku.barcodes.create!(
        attributes_for(:barcode, barcode: '11111', sku: existing_unsized_sku)
      )
    end

    context 'new sku has the same barcode as existing unsized sku' do
      let!(:new_sku) do
        create(
          :base_sku,
          :sized,
          season: season,
          manufacturer_sku: existing_unsized_sku.manufacturer_sku
        )
      end

      subject { described_class.new.export(new_sku) }

      before do
        new_sku.barcodes.create!(
          attributes_for(:barcode, barcode: '11111', sku: existing_unsized_sku)
        )
        remove_attrs_that_wont_exist_yet(new_sku)
      end

      it 'the new sku\'s option is not nil' do
        expect(subject.option).to_not be nil
      end

      it 'the new sku\'s element is not nil' do
        expect(subject.element).to_not be nil
      end

      it 'the new sku\'s language_product_option is not nil' do
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
          season: season,
          manufacturer_sku: existing_unsized_sku.manufacturer_sku
        )
      end

      subject { described_class.new.export(new_sku) }

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

  def remove_attrs_that_wont_exist_yet(sku)
    sku.option.delete
    sku.element.delete
    sku.language_product_option.delete
    sku.reload
    sku.save!
  end
end
