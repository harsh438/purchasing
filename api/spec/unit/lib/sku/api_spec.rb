describe Sku::Api do
  let (:url) { Sku::Api.new.config['url'] }

  before(:each) do
    stub_request(:post, Regexp.new(url))
      .to_return(status: 200, body: { m_sku: '12345',
                                      size: 'Small',
                                      extra_detail: 'Cool' }.to_json)

    stub_request(:post, Regexp.new(url + '/timeout')).to_timeout
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
                            url + '/timeout') }.to raise_error(Excon::Errors::Timeout)
    end
  end
end
