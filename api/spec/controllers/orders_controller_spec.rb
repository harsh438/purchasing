require 'spec_helper'

RSpec.describe OrdersController do
  include JSONFixture

  let(:order_json) { fixture('spec/fixtures/files/sample_order.json') }
  let(:line_item_json) { fixture('spec/fixtures/files/sample_line_items.json') }

  describe 'create' do
    it 'with attributes' do
      post :create, order_json.obj.merge(format: :json)
      expect(response.status).to eq 200
      data = JSON.parse(response.body)
      expect(data['id']).to eq 1
      expect(data['name']).to eq order_json.obj['order']['name']
      expect(data['order_type']).to eq order_json.obj['order']['order_type']
    end
  end

  describe 'update' do
    let!(:order) { create(:order) }
    let!(:sku) { create(:base_sku, :sized, sku: 'test_01') }
    it 'with attributes' do
      post :update, line_item_json.obj.merge(format: :json, id: order.id)
      expect(response.status).to eq 200
      data = JSON.parse(response.body)
      expect(data['id']).to eq order.id
      expect(data['id']).to eq data['line_items'].first['order_id']
      expect(data['line_items'].count).to eq 1
    end
  end

  describe 'export' do
    let!(:line_items) { create(:order_line_item) }
    let(:last_po) { PurchaseOrderLineItem.last }

    it 'with attributes' do
      post :export, export_params
      data = JSON.parse(response.body)
      exports = data.first['exports']
      expect(data.first['status']).to eq 'exported'
      expect(exports.count).to eq 1
      expect(last_po.attributes.fetch('status')).to eq 2
      expect(last_po.id).to eq exports.first['purchase_order_id']
    end
  end
end

def export_params
  {
    id: line_items.order_id,
    operator: 'OT_100',
    format: :json
  }
end
