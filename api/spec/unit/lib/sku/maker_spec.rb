require 'helpers/missing_attributes_helper'

RSpec.describe Sku::Maker do
  include MissingAttributesHelper

  describe 'create_or_update_references' do
    let(:unsized_attrs_class) { double 'Sku::UnsizedMissingAttributes' }
    let(:sized_attrs_class) { double 'Sku::SizedMissingAttributes' }
    let(:sku_attrs) do
      existing_sku.attributes.except(:id, :created_at, :updated_at).merge( { season: season })
    end
    let!(:po_line_item) { create(:purchase_order_line_item, unsized_attrs) }
    let(:season) { Season.find_by(id: 24) }

    subject do
      described_class.new(unsized_attrs: unsized_attrs_class, sized_attrs: sized_attrs_class)
    end

    before do
      allow(unsized_attrs_class).to receive(:retrieve_attributes).and_return(sku_attrs)
      allow(unsized_attrs_class).to receive(:missing_sku_id).and_return(missing_sku_id)
      allow(sized_attrs_class).to receive(:retrieve_attributes).and_return(sku_attrs)
    end

    context 'When the missing sku is a duplicate of an existing sku' do
      let!(:existing_sku) { create(:base_sku, :with_barcode, season: season) }
      let!(:barcode) do
        create(:barcode, barcode: existing_sku.barcodes.first.barcode, sku_id: missing_sku_id)
      end

      it 'it updates the barcodes table to point to the exisitng sku' do
        subject.create_or_update_references
        expect(Barcode.all.map(&:sku_id)).to_not include missing_sku_id
      end

      it 'it updates the purchase_orders table to point to the exisitng sku' do
        subject.create_or_update_references
        expect(PurchaseOrderLineItem.all.map(&:sku_id)).to_not include missing_sku_id
      end
    end

    context 'when the missing sku is not a duplicate of an exisitng sku' do
      let(:sku_attrs) { attributes_for(:base_sku) }

      it 'sends the sku attributes to the sku generator' do
        expect { subject.create_or_update_references }.to change { Sku.count }.by(1)
      end
    end
  end
end
