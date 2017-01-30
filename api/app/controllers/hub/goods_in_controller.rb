class Hub::GoodsInController < ApplicationController
  before_filter :validate_grn, only: [:create]
  before_filter :validate_ref, only: [:create]

  rescue_from ActionController::ParameterMissing,
    with: :handle_missing_parameters

  def create
    items.each do |item|
      attrs = attributes(item)
      pvx_in = PvxIn.create(attrs)
      reconcile(pvx_in) if pvx_in.present?
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

  def reconcile(pvx_in)
    PvxInReconcileWorker.perform_async(pvx_in.id)
  end

  def attributes(item)
    {
      sku: item[:sku],
      ref: reference,
      qty: item[:quantity],
      po_number: normalise_po_number(item),
      logged: reconciled_date,
      UserId: user_id,
      DeliveryNote: delivery_note,
      pid: item[:product_id],
    }
  end

  def normalise_po_number(item)
    po_number = item[:purchase_order_number]
    return po_number unless po_number
    po_number.split('_').first
  end

  def request_id
    params.require(:request_id)
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
    render json: { summary: 'Bad object' }, status: 500
  end

  def validate_grn
    render json: { summary: 'GRN does not exist' }, status: 500 unless grn.present?
  end

  def validate_ref
    render json: { summary: 'Ref already exists' }, status: 500 unless ref.blank?
  end
end
