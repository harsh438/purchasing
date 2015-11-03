class CategoriesController < ApplicationController
  def index
    render json: Category.relevant
  end
end
