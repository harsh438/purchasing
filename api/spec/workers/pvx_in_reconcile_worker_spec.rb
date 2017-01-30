require 'spec_helper'

RSpec.describe PvxInReconcileWorker do
  include_context 'reconcile context'

  let(:worker) { described_class.new }

  it "sucessfully reconcile purchase order" do
    result = worker.perform(pvx_in.id)
    expect(result).to eq true
  end

  it "sucessfully normalize goods in message" do
    pvx_in.update_attribute(:po_number, nil)
    result = worker.perform(pvx_in.id)
    expect(result).to eq true
  end

  it "unsucessfully with invalid input" do
    result = worker.perform(99999)
    expect(result).to eq false
  end
end
