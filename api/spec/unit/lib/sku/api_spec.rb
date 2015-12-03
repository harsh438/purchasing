describe Sku::Api do
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
      expect(JSON.parse(response.body)['barcode']).to include('5052094029950')
    end

    it 'should return a 204 for nonexistent skus' do
      expect(nonexistent_response.headers['status']).to include('204')
    end
  end
end
