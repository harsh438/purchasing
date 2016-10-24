require 'spec_helper'

RSpec.describe OverPurchaseOrdersController do
  include JSONFixture

  let(:over_po) { fixture('spec/fixtures/files/sample_over_po.json') }
  let(:internal_sku_error_message) do
    'Internal SKU does not exist for any season: ' \
    "#{over_po.obj['over_po']['sku']}"
  end

  describe 'create' do
    context 'with valid sku' do
      let!(:purchase_order) do
        create(:purchase_order_line_item,
               :with_summary,
               sku_id: sku.id,
               po_number: over_po.obj['over_po']['po_numbers'].first
              )
      end
      let(:sku) do
        create(:base_sku,
               :with_barcode,
               :with_product,
               season: Season.all[5],
               sku: over_po.obj['over_po']['sku']
              )
      end
      let(:last_po) { PurchaseOrderLineItem.last }

      it 'with attributes' do
        post :create, over_po.obj.merge(format: :json)
        data = JSON.parse(response.body).first
        exports = data['exports']
        expect(data['status']).to eq 'exported'
        expect(data['order_type']).to eq 'over_po'
        expect(exports.first['purchase_order_id']).to eq last_po.id
        expect(data['line_items'].count).to eq exports.count
        expect(last_po.attributes.fetch('status')).to eq 2
        expect(last_po.quantity_done).to eq 0
        expect(last_po.operator).to eq 'O_U_TOOL'
        expect(last_po.id).to eq exports.first['purchase_order_id']
        expect(data['name']).to eq "OVER_#{OverDelivery.last.id}"
      end
    end

    context 'with invalid sku' do
      it 'raises caught internal sku error' do
        post :create, over_po.obj.merge(format: :json)
        data = JSON.parse(response.body)
        expect(data['summary']).to eq internal_sku_error_message
      end
    end

    context 'record invalid' do
      let(:over_delivery) { OverDelivery.new }
      before { over_delivery.errors.add(:sku, 'some random error here') }

      it 'error is handled' do
        allow(OverDelivery).to receive(:create!).and_raise(ActiveRecord::RecordInvalid, over_delivery)
        post :create, over_po.obj.merge(format: :json)
        data = JSON.parse(response.body)
        expect(data['summary']).to eq 'Validation failed: Sku some random error here'
      end
    end

    context 'Missing parameters' do
      %w(sku grn quantity user_id po_numbers).each do |attribute|
        context "missing #{attribute}" do
          let(:over_po) do
            modify_fixture('spec/fixtures/files/sample_over_po.json') do |json|
              json.delete!("$..over_po.#{attribute}")
            end.obj[0]
          end
          it "raises error message" do
            post :create, over_po.merge(format: :json)
            data = JSON.parse(response.body)
            expect(data['summary']).to eq "param is missing or the value is empty: #{attribute}"
          end
        end
      end
    end
  end
end
