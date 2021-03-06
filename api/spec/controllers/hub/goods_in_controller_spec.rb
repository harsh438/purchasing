require 'spec_helper'

RSpec.describe Hub::GoodsInController do
  include JSONFixture

  let(:request_id) { Faker::Crypto.md5 }
  let(:json) { fixture('spec/fixtures/files/sample_goods_in.json') }
  let(:goods_in) { json['goods_in'] }
  let(:delivery_note) { goods_in['delivery_note'] }
  let(:item_count) { goods_in['items'].count }

  context "valid delivery_note" do
    let(:json) do
      modify_fixture('spec/fixtures/files/sample_goods_in.json') do |json|
      end.obj[0]
    end

    before do
      allow(GoodsReceivedNotice).to receive(:find_by).and_return(delivery_note)
    end

    it 'has a valid wombat response' do
      post :create, json.merge(format: :json, request_id: request_id)
      expect(JSON.load(response.body)).to include(
        "summary"    => format(
          '%d %s added',
          item_count,
          'goods_in line'.pluralize(item_count)
        ),
        "request_id" => request_id,
      )
    end

    context 'creates PvxIn' do
      it "with correct data (chunked po_num)" do
        post :create, json.merge(format: :json, request_id: request_id)
        pvx_in = PvxIn.find_by(sku: goods_in['items'].first['sku'])
        expect(pvx_in).to have_attributes(
          sku: goods_in['items'].first['sku'],
          ref: goods_in['reference'],
          ponum: goods_in['items'].first['purchase_order_number'].split('_').first,
          qty: goods_in['items'].first['quantity'],
          UserId: goods_in['user_id'],
          DeliveryNote: delivery_note,
          pid: goods_in['items'].first['product_id'],
        )
      end
      it "with NULL po_num" do
        post :create, json.merge(format: :json, request_id: request_id)
        pvx_in = PvxIn.find_by(sku: goods_in['items'].second['sku'])
        expect(pvx_in).to have_attributes(
          ponum: goods_in['items'][1]['purchase_order_number'],
        )
      end
      it "with unchunked PO num" do
        post :create, json.merge(format: :json, request_id: request_id)
        pvx_in = PvxIn.find_by(sku: goods_in['items'].third['sku'])
        expect(pvx_in).to have_attributes(
          ponum: goods_in['items'][2]['purchase_order_number'],
        )
      end
      it "correct number of records" do
        expect {
          post :create, json.merge(format: :json, request_id: request_id)
        }.to change { PvxIn.count }.by(item_count)
      end
    end

    context 'missing parameters' do
      let(:json) do
        modify_fixture('spec/fixtures/files/sample_goods_in.json') do |json|
          json.delete!('$..delivery_note')
        end.obj[0]
      end
      it_should_behave_like 'an error response', 'Bad object'
    end

    context 'empty items' do
      let(:json) do
        modify_fixture('spec/fixtures/files/sample_goods_in.json') do |json|
          json.gsub!('$..items') { [] }
        end.obj[0]
      end
      it_should_behave_like 'an error response', 'Bad object'
    end

    context 'reference already in db' do
      before { allow(PvxIn).to receive(:find_by).and_return(double()) }
      let(:json) do
        modify_fixture('spec/fixtures/files/sample_goods_in.json') do |json|
        end.obj[0]
      end
      it_should_behave_like 'an error response', 'Ref already exists'
    end
  end

  context 'invalid delivery_note' do
    let(:json) do
      modify_fixture('spec/fixtures/files/sample_goods_in.json') do |json|
      end.obj[0]
    end
    it_should_behave_like 'an error response', 'GRN does not exist'
  end
end
