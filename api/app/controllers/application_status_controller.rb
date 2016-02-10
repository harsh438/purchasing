class ApplicationStatusController < ActionController::Base
  def index
    render json: { status: :ok }
  end
end
