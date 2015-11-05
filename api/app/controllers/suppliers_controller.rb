class SuppliersController < ApplicationController
  def index
    render json: Supplier.mapped.relevant.alphabetical
  end
end
