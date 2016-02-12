class UsersController < ApplicationController
  def index
    render json: User.where(active: 1)
  end
end
