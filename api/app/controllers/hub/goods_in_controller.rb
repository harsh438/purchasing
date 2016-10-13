class Hub::GoodsInController < ApplicationController
  before_filter :validate_grn, only: [:create]
  before_filter :validate_ref, only: [:create]

  rescue_from ActionController::ParameterMissing,
    with: :handle_missing_parameters

  def create
    items.each do |item|
      attrs = attributes(item)
      PvxIn.create(attrs)
    end
    render json: {
      request_id: request_id,
      summary: format(
        '%d %s added',
        items.count,
        'goods_in line'.pluralize(items.count)
      ),
    }
  end

  private

  def attributes(item)
    {
      sku: item[:sku],
      ref: reference,
      qty: item[:quantity],
      ponum: item[:purchase_order_number],
      logged: reconciled_date,
      UserId: user_id,
      DeliveryNote: delivery_note,
      pid: product_id(item),
    }
  end

  def request_id
    params.require(:request_id)
  end

  def product_id(item)
    Sku.find_by(sku: item[:sku]).product_id
  end

  def reference
    params.require(:goods_in).require(:reference)
  end

  def delivery_note
    params.require(:goods_in).require(:delivery_note)
  end

  def user_id
    params.require(:goods_in).require(:user_id)
  end

  def reconciled_date
    params.require(:goods_in).require(:reconciled_date)
  end

  def items
    params.require(:goods_in).require(:items)
  end

  def grn
    GoodsReceivedNotice.find_by(grn: delivery_note)
  end

  def ref
    PvxIn.find_by(ref: reference)
  end

  def handle_missing_parameters
    render text: 'Bad object', status: 500
  end

  def validate_grn
    render text: 'GRN does not exist', status: 500 unless grn.present?
  end

  def validate_ref
    render text: 'Ref already exists', status: 500 unless ref.blank?
  end
end
