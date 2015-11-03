class SuppliersController < ApplicationController
  def index
    render json: Supplier.mapped.relevant
  end
end
