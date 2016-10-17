require 'helpers/missing_attributes_helper'

RSpec.describe Sku::SizedMissingAttributes do
  include MissingAttributesHelper

  describe '#retrieve_attributes' do
    before do
      setup
      create(:purchase_order_line_item, sized_attrs)
      create(:element, id: 15, name: 'S')
    end
    let(:unsized_missing_attrs) { Sku::UnsizedMissingAttributes.new(missing_sku_id) }
    let(:unsized_fixture) { JSON.load(File.read(path + 'unsized_sku_fixture.json')) }
    let(:sized_fixture) { path + 'sized_sku_fixture.json' }

    subject { described_class.new(unsized_missing_attrs).retrieve_attributes }

    it 'inherits the retrieved attributes from the UnsizedMissingAttributes class' do
      expect(unsized_missing_attrs).to receive(:retrieve_attributes).and_return(unsized_fixture)
      subject
    end

    it 'extends the inherited retrieve_attributes' do
      expect(JSON.pretty_generate(subject).strip).to eq(File.read(sized_fixture).strip)
    end
  end
end
