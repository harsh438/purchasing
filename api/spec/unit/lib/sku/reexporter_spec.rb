require 'spec_helper'

RSpec.describe Sku::Reexporter do
  describe "#re_export" do
    let!(:sku) { create(:base_sku) }
    let(:csv_path) { 'spec/fixtures/files/sample_reexporter.csv' }
    let(:exporter) { Sku::Exporter.new }
    let(:logger) { Logger.new(STDOUT) }

    subject { described_class.new(exporter, logger, csv_path) }

    before { File.open(csv_path, 'w') { |f| f << sku.id } }

    it 'calls Sku::Export' do
      expect(exporter).to receive(:export).with(sku)
      subject.re_export
    end

    it 'logs the sku before and after the re-epxport' do
      expect(logger).to receive(:info).twice
      subject.re_export
    end
  end
end
