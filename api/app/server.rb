require 'sinatra'
require_relative 'database'
require_relative 'models/purchase_order'

get '/' do
  PurchaseOrder.first(5).to_json
end