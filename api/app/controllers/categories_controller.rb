class CategoriesController < ApplicationController
  def index
    render json: Category.english
  end
end
