shared_examples 'an error response' do |message|
  it 'returns a 500' do
    post :create, json.merge(format: :json, request_id: request_id)
    expect(response.status).to eq(500)
    expect(response.body).to eq(message)
  end
end
