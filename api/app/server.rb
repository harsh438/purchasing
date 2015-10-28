require 'sinatra'
require_relative 'database'
require_relative 'models/purchase_order'

get '/' do
  content_type :json
  PurchaseOrder.first(5).to_json
end