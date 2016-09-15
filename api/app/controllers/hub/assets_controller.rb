class Hub::AssetsController < ApplicationController
  before_filter :validate_action, only: [:create]

  rescue_from ActionController::ParameterMissing,
    with: :handle_missing_parameters

  def create
    service = ProductImageBatchService.new
    asset_count = service.send("#{action}_assets", product_id, batch_id, assets).try(:size)
    render json: {
      request_id: request_id,
      summary: format(
        '%d %s have been updated',
        asset_count,
        'product asset'.pluralize(asset_count),
      ),
    }
  end

  private

  def request_id
    params.require(:request_id)
  end

  def product_id
    params.require(:product_asset).require(:pid)
  end

  def action
    params.require(:product_asset).require(:action).try(:to_s)
  end

  def batch_id
    params.require(:product_asset).require(:id)
  end

  def assets
    params.require(:product_asset)
          .require(:assets)
  end

  def handle_missing_parameters
    render text: 'Bad object', status: 500
  end

  def validate_action
    unless ProductImageBatchService::SUPPORTED_ACTIONS.include? action
      render text: 'Wrong action status', status: 500
    end
  end
end
