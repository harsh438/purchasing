RSpec.describe Sku::Api do
  let (:url) { Sku::Api.new.config['url'] }

  context 'Retrieving sku information from the API' do
    let(:response) do
      VCR.use_cassette 'good_sku' do
        subject.find({ man_sku: 'SV507-A59', size: '14' })
      end
    end

    let(:nonexistent_response) do
      VCR.use_cassette 'nonexistent_sku' do
        subject.find({ man_sku: '12345', size: 'Small' })
      end
    end

    it 'should find a sku in the sku API and return previously unknown information on it' do
      expect(response.fields[:barcodes_attributes][0][:barcode]).to eq('5052094029950')
    end

    it 'should return a 204 for nonexistent skus' do
      expect(nonexistent_response.status).to eq(204)
    end
  end
end
