describe Sku::Api do
  before(:each) do
    stub_request(:get, Regexp.new(Sku::Api.new.url + '\?.*'))
      .to_return(status: 200, body: { m_sku: '12345',
                                      size: 'Small',
                                      extra_detail: 'Cool' }.to_json)

    stub_request(:get, Regexp.new(Sku::Api.new.url + '/timeout')).to_timeout
  end

  context 'Retrieving sku information from the API' do
    let(:response) { subject.find({ m_sku: '12345', size: 'Small' }) }

    it 'should find a sku in the sku API and return previously unknown information on it' do
      expect(JSON.parse(response.body)['extra_detail']).to eq('Cool')
    end
  end

  context 'Handling API timeouts' do
    it 'should explode' do
      expect { subject.find({ m_sku: '12345', size: 'Small' },
                            Sku::Api.new.url + '/timeout') }.to raise_error(Excon::Errors::Timeout)
    end
  end
end
