require "#{File.dirname(__FILE__)}/helpers/spec_helper.rb"

describe 'Sinatra server' do
  context 'Visiting the homepage' do
    it 'should return a response' do
      visit '/'
      expect(page.body).to include('Purchasing')
    end
  end
end