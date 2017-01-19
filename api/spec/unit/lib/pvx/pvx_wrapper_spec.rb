require 'spec_helper'
require 'json'

RSpec.describe PVX::Wrapper do
  let(:base_url) { Purchasing::Application.config.pvx_credentials[:base_url] }
  let(:pvx_sku)  do
    {
      sku: '18312-13',
      barcode: '5052094029950',
      manufacturer_sku: 'SV507-A59',
      manufacturer_size: '14',
      size: '14'
    }
  end

  describe '#sku_by_barcode_and_surfdome_size' do
    context '200 response' do
      let(:response) do
        VCR.use_cassette 'pvx_sku_by_barcode_and_surfdome_size_200' do
          subject.sku_by_barcode_and_surfdome_size(pvx_sku[:barcode], pvx_sku[:size])
        end
      end

      it 'returns the correct sku data' do
        expect(response.code).to eq 200
        expect(JSON.parse(response.to_s, symbolize_names: true)).to eq pvx_sku
      end
    end

    context '204 response (no sku found)' do
      let(:response) do
        VCR.use_cassette 'pvx_sku_by_barcode_and_surfdome_size_204' do
          subject.sku_by_barcode_and_surfdome_size('000001', '10')
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
          base_url: base_url
        }
      end

      let(:response) do
        VCR.use_cassette 'pvx_sku_by_barcode_and_surfdome_size_401' do
          subject.sku_by_barcode_and_surfdome_size(pvx_sku[:barcode], pvx_sku[:size])
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
        stub_request(:post, "#{base_url}/sku_lookup_by_barcode_and_surfdome_size").to_timeout
      end

      it 'raises an error if the retries fail' do
        expect { subject.sku_by_barcode_and_surfdome_size(pvx_sku[:barcode], pvx_sku[:size]) }
          .to raise_error(PVXTimeoutError)
      end
    end
  end

  describe '#sku_by_barcode' do
    context '200 response' do
      let(:response) do
        VCR.use_cassette 'pvx_sku_by_barcode_200' do
          subject.sku_by_barcode(pvx_sku[:barcode])
        end
      end

      it 'returns the correct sku data' do
        expect(response.code).to eq 200
        expect(JSON.parse(response.to_s, symbolize_names: true)).to eq pvx_sku
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
          base_url: base_url
        }
      end

      let(:response) do
        VCR.use_cassette 'pvx_sku_by_barcode_401' do
          subject.sku_by_barcode(pvx_sku[:barcode])
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
        stub_request(:post, "#{base_url}/sku_lookup_by_barcode").to_timeout
      end

      it 'raises an error if the retries fail' do
        expect { subject.sku_by_barcode(pvx_sku[:barcode]) }.to raise_error(PVXTimeoutError)
      end
    end
  end

  describe '#sku_by_man_sku_and_man_size' do
    context '200 response' do
      let(:response) do
        VCR.use_cassette 'pvx_by_man_sku_and_man_size_200' do
          subject.sku_by_man_sku_and_man_size(
            pvx_sku[:manufacturer_sku], pvx_sku[:manufacturer_size]
          )
        end
      end

      it 'should find a sku in the sku API and return sku object' do
        expect(response.code).to eq 200
        expect(JSON.parse(response.to_s, symbolize_names: true)).to eq pvx_sku
      end
    end

    context '204 response' do
      let(:response) do
        VCR.use_cassette 'pvx_by_man_sku_and_man_size_204' do
          subject.sku_by_man_sku_and_man_size('12345', 'Small')
        end
      end

      it 'should return a 204 for nonexistent skus' do
        expect(response.code).to eq 204
        expect(response.parsed_response).to eq nil
      end
    end
  end
end
