require 'spec_helper'

RSpec.describe OverPurchaseOrdersController do
  include JSONFixture

  let(:over_po) { fixture('spec/fixtures/files/sample_over_po.json') }

  describe 'create' do
    context 'with correct sku' do
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

      context 'correct season' do
        it 'generates over po' do
          post :create, over_po.obj.merge(format: :json)
          data = JSON.parse(response.body).first
          expect_over_po_data_to_have_correct_info(data)
        end
      end

      context 'wrong season' do
        before { sku.update(season: Season.all[4]) }

        context 'correct barcode' do
          it 'generates sku for correct season, and generates over po' do
            expect { post :create, over_po.obj.merge(format: :json) }.to change(Sku, :count).by(1)
            data = JSON.parse(response.body).first
            expect_over_po_data_to_have_correct_info(data)
          end
        end
        context 'no barcode' do
          let(:sku) { create(:base_sku, :with_product, sku: over_po.obj['over_po']['sku']) }

          it 'raises  error' do
            message = 'Couldn\'t find Barcode'
            expect_create_to_handle_error_with(over_po.obj, message)
          end
        end
      end
    end

    context 'with invalid sku' do
      it 'raises caught internal sku error' do
        message = 'Couldn\'t find Sku'
        expect_create_to_handle_error_with(over_po.obj, message)
      end
    end

    context 'record invalid' do
      let(:over_delivery) { OverDelivery.new }
      before { over_delivery.errors.add(:sku, 'some random error here') }

      it 'error is handled' do
        allow(OverDelivery).to receive(:create!).and_raise(ActiveRecord::RecordInvalid, over_delivery)
        message = 'Validation failed: Sku some random error here'
        expect_create_to_handle_error_with(over_po.obj, message)
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
            message = "param is missing or the value is empty: #{attribute}"
            expect_create_to_handle_error_with(over_po, message)
          end
        end
      end
    end
  end
end

def expect_over_po_data_to_have_correct_info(data)
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

def expect_create_to_handle_error_with(over_po, message)
  post :create, over_po.merge(format: :json)
  data = JSON.parse(response.body)
  expect(data['summary']).to eq message
end
