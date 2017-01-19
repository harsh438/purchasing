RSpec.shared_context "exisiting unsized sku that's also in in PVX" do
  let(:pvx_sku)  do
    {
      sku: '100010',
      barcode: '700285558479',
      manufacturer_sku: '57-786-',
      manufacturer_size: '',
      size: ''
    }
  end

  let(:barcode) { create(:barcode, barcode: pvx_sku[:barcode]) }

  let(:product) do
    create(
      :product,
      id: pvx_sku[:sku],
      manufacturer_sku: pvx_sku[:manufacturer_sku],
      barcode: barcode,
      sized: false
    )
  end

  let!(:existing_unsized_sku) do
    create(
      :base_sku, :with_product, :with_barcode,
      product: product,
      barcode: barcode,
      sku: pvx_sku[:sku],
      manufacturer_sku: pvx_sku[:manufacturer_sku],
      season: Season.first
    )
  end
end
