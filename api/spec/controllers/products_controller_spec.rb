require 'spec_helper'

RSpec.describe ProductsController do
  let(:product) { create(:product, id: 1234) }

  context 'valid payload' do
    before do
      create(:purchase_order_line_item,
        :with_product,
        product: product,
        cost: 200,
        product_rrp: 4000
      )
    end

    it 'returns product price data' do
      get :prices, { product_id: product.id, format: :json }
      expect(response.status).to eq 200
      expect(JSON.load(response.body)['cost_price']).to eq 200
      expect(JSON.load(response.body)['brand_rrp']).to eq 4000
      expect(JSON.load(response.body)['product_id']).to eq 1234
    end
  end

  context 'invalid payload' do
    it 'when product_id doesn\'t exist we 204' do
      get :prices, { product_id: 5678, format: :json }
      expect(response.status).to eq 204
    end
  end
end
