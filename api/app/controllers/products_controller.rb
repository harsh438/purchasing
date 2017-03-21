class ProductsController < ApplicationController
  def prices
    return head :no_content if data.blank?
    render json: price_object
  end

  private

  def product_id
    params.require(:product_id)
  end

  def price_object
    {
      product_id: product_id,
      brand_rrp: data.first,
      cost_price: data.second
    }
  end

  def data
    @data ||= PurchaseOrderLineItem.where(product_id: product_id)
                         .order(id: :desc)
                         .limit(1)
                         .pluck(:product_rrp, :cost).flatten
  end
end
