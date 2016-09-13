require 'spec_helper'

RSpec.describe Hub::AssetsController do
  include JSONFixture

  shared_examples 'an error response' do |message|
    it 'returns a 500' do
      post :create, json.merge(format: :json)
      expect(response.status).to eq(500)
      expect(response.body).to eq(message)
    end
  end

  describe 'POST /' do
    context 'without a PID' do
      let(:json) do
        modify_fixture('spec/fixtures/files/sample_asset.json') do |json|
          json.delete!('$..pid')
          json.delete!('$..pids')
        end.obj[0]
      end

      it_should_behave_like 'an error response', 'Bad object'
    end

    context 'with an invalid action' do
      let(:json) do
        modify_fixture('spec/fixtures/files/sample_asset.json') do |json|
          json.gsub!('$..action') { 'foobar' }
        end.obj[0]
      end

      it_should_behave_like 'an error response', 'Wrong action status'
    end

    context 'with no assets' do
      let(:json) do
        modify_fixture('spec/fixtures/files/sample_asset.json') do |json|
          json.gsub!('$..assets') { [] }
        end.obj[0]
      end

      it_should_behave_like 'an error response', 'Bad object'
    end

    context 'with a valid payload' do
      let(:product) { create(:product) }
      let(:batch_id) { 1234 }

      %w( replace append prepend ).each do |action|
        context "when performing a #{action.inspect}" do
          let(:json) do
            modify_fixture('spec/fixtures/files/sample_asset.json') do |json|
              json.gsub!('$..pid') { product.id }
              json.gsub!('$..pids') { product.id }
              json.gsub!('$..product_asset.id') { batch_id }
              json.gsub!('$..action') { action }
            end.obj[0]
          end

          it 'calls the relevant service method' do
            expect_any_instance_of(ProductImageBatchService)
              .to receive("#{action}_assets")
              .with(product.id, batch_id, json['product_asset']['assets']) do
                [double(:asset), double(:asset)]
              end
            post :create, json.merge(format: :json)
            expect(response).to be_success
          end
        end
      end

    end
  end
end
