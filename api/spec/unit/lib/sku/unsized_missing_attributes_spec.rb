require 'helpers/missing_attributes_helper'

RSpec.describe Sku::UnsizedMissingAttributes do
  include MissingAttributesHelper

  describe '#retrieve_attributes' do
    let(:required_attributes) do
      Sku::UnsizedMissingAttributes::ATTRS_FROM_LINE_ITEM.keys +
      Sku::UnsizedMissingAttributes::ATTRS_FROM_PRODUCT.keys
    end
    let(:fixture) { path + 'unsized_sku_fixture.json' }

    context 'sku IS missing' do
      before do
        setup
        create(:purchase_order_line_item, unsized_attrs)
      end

      subject { described_class.new(missing_sku_id).retrieve_attributes }

      it 'builds a hash including each of the required attributes' do
        required_attributes.each do |key, _value|
          expect { subject.fetch(key) }.to_not raise_error
        end
      end

      it 'builds the correct data' do
        expect(JSON.pretty_generate(subject).strip).to eq(File.read(fixture).strip)
      end
    end

    context 'Sku is NOT missing when...' do
      it 'The sku is in the skus table' do
        sku = create(:base_sku)
        expect { described_class.new(sku.id).retrieve_attributes }
        .to raise_exception(ArgumentError, 'Sku is not missing')
      end

      it 'the sku is not in the sku table OR the purchase_orders table\
          (in this case it\'s not missing; it doesn\'t exist)' do
        expect { described_class.new(missing_sku_id).retrieve_attributes }
        .to raise_exception(ArgumentError, 'Sku is not missing')
      end
    end
  end
end
