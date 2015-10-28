require 'sinatra'
require_relative 'database'
require_relative 'models/purchase_order'

set :root, File.dirname(__FILE__) + '/../'

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/api/purchase_orders.json' do
  content_type :json
  PurchaseOrder.first(5).to_json
end
