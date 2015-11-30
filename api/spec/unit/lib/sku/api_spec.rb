describe Sku::Api do
  before(:each) do
    stub_request(:get, Regexp.new(Sku::Api.new.url + '.*'))
      .to_return(status: 200, body: { m_sku: '12345',
                                      size: 'Small',
                                      extra_detail: 'Cool' }.to_json)
  end

  context 'Retrieving sku information from the API' do
    let(:response) { subject.find(m_sku: '12345', size: 'Small') }

    it 'should find a sku in the sku API and return previously unknown information on it' do
      expect(JSON.parse(response.body)['extra_detail']).to eq('Cool')
    end
  end
end
