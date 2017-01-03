require 'spec_helper'
require 'json'

RSpec.describe PVX::Wrapper do
  describe '#sku_by_barcode' do
    context '200 response' do
      let(:response) do
        VCR.use_cassette 'pvx_sku_by_barcode_200' do
          subject.sku_by_barcode('9321977524209')
        end
      end

      it 'returns the correct sku data' do
        expect(response.code).to eq 200
        expect(JSON.parse(response.to_s, symbolize_names: true)[:sku]).to eq '85791'
      end
    end

    context '204 response (no sku found)' do
      let(:response) do
        VCR.use_cassette 'pvx_sku_by_barcode_204' do
          subject.sku_by_barcode('000001')
        end
      end

      it 'returns nil' do
        expect(response.code).to eq 204
        expect(response.parsed_response).to eq nil
      end
    end

    context '401 response - invalid credentials' do
      let(:stubbed_credentials) do
        {
          key: 1,
          token: 'invalid_token',
          base_url: Purchasing::Application.config.pvx_credentials[:base_url]
        }
      end

      let(:response) do
        VCR.use_cassette 'pvx_sku_by_barcode_401' do
          subject.sku_by_barcode('9321977524209')
        end
      end

      before do
        allow_any_instance_of(PVX::Wrapper).to receive(:credentials).and_return(stubbed_credentials)
      end

      it 'returns an Authorization failure message' do
        expect(response.code).to eq 401
        expect(response.parsed_response).to eq 'Authorization failure'
      end
    end

    context '500 response - timeout' do
      before do
        stub_request(:post, "#{Purchasing::Application.config.pvx_credentials[:base_url]}/sku_lookup_by_barcode").to_timeout
      end

      it 'raises an error if the retries fail' do
        expect { subject.sku_by_barcode('9321977524209') }.to raise_error(PVXTimeoutError)
      end
    end
  end

  describe '#sku_by_man_sku_and_size' do
    context '200 response' do
      let(:response) do
        VCR.use_cassette 'pvx_by_man_sku_and_size_200' do
          subject.sku_by_man_sku_and_size('SV507-A59', '14')
        end
      end

      it 'should find a sku in the sku API and return previously unknown information on it' do
        expect(response.code).to eq 200
        expect(JSON.parse(response.to_s, symbolize_names: true)[:barcode]).to eq '5052094029950'
      end
    end

    context '204 response' do
      let(:response) do
        VCR.use_cassette 'pvx_by_man_sku_and_size_204' do
          subject.sku_by_man_sku_and_size('12345', 'Small')
        end
      end

      it 'should return a 204 for nonexistent skus' do
        expect(response.code).to eq 204
        expect(response.parsed_response).to eq nil
      end
    end
  end
end
