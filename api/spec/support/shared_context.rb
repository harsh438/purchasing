shared_examples 'an error response' do |message|
  it 'returns a 500' do
    post :create, json.merge(format: :json, request_id: request_id)
    expect(response.status).to eq(500)
    expect(JSON.load(response.body)).to include('summary' => message)
  end
end
