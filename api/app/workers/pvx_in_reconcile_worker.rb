class PvxInReconcileWorker
  include Sidekiq::Worker

  def perform(pvx_in_id)
    pvx_in = PvxIn.find_by(id: pvx_in_id)
    return false if pvx_in.blank?
    pvx_in_po_line = GoodsIn::Normalizer.new(pvx_in).process
    return true if pvx_in_po_line.try(:status) < 0
    PurchaseOrder::Reconciler.new(pvx_in_po_line).reconcile
  end
end
