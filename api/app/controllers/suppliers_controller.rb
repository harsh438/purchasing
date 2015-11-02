class SuppliersController < ApplicationController
  def index
    render json: Supplier.mapped
  end
end
