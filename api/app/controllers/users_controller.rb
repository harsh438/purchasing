class UsersController < ApplicationController
  def index
    render json: User.where(active: 1).order(name: :asc)
  end
end
