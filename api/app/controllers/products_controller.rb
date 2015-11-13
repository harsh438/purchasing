class ProductsController < ApplicationController
  def show
    render json: product
  end

  private

  def product
    @product ||= Product.find_by(id: params[:id])
  end
end
