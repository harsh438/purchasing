class ProductsController < ApplicationController
  def index
    render json: Product.first(10)
  end
end
