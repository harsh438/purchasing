require 'paper_trail/frameworks/rspec'

shared_examples_for 'a resource requiring ONLY creates, updates, destroys logged' do
  it_behaves_like 'a resource requiring creations logged'
  it_behaves_like 'a resource requiring edits logged'
  it_behaves_like 'a resource requiring destroys logged'
end

shared_examples_for 'a resource requiring creations logged' do
  subject { resource.save }

  example 'creation logged' do
    expect { subject }.to change { resource.versions.count }.from(0).to(1)
  end
end

shared_examples_for 'a resource requiring edits logged' do
  def params
    case resource
    when PurchaseOrder then { status: 2 }
    when PurchaseOrderLineItem then { orderTool_barcode: '101010101' }
    end
  end

  subject { resource.update(params) }

  example 'edits logged when performed by logged in user' do
    resource.save unless resource.persisted?
    expect { subject }.to change { resource.versions.count }.by(1)
  end
end

shared_examples_for 'a resource requiring destroys logged' do
  subject { resource }

  it 'destroys logged' do
    resource.save unless resource.persisted?
    expect { subject.destroy }.to change { resource.versions.count }.by(1)
  end
end

describe 'models with paper trail', type: :model, versioning: true, papertrail: true do
  context 'ONLY creates, updates, destroys logged' do
    describe PurchaseOrder do
      let(:resource) { build(:purchase_order) }
      it_behaves_like 'a resource requiring ONLY creates, updates, destroys logged'
    end
    describe PurchaseOrderLineItem do
      let(:resource) { build(:purchase_order_line_item) }
      it_behaves_like 'a resource requiring ONLY creates, updates, destroys logged'
    end
  end
end
