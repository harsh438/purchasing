RSpec.shared_context "exisiting sized sku that's also in in PVX" do
  let(:pvx_sku)  do
    {
      sku: '18312-13',
      barcode: '5052094029950',
      manufacturer_sku: 'SV507-A59',
      manufacturer_size: '14',
      size: '14'
    }
  end

  let(:element) { create(:element, elementID: 1666, elementname: pvx_sku[:size]) }

  let(:barcode) { create(:barcode, barcode: pvx_sku[:barcode]) }

  let(:product) { create(:product, id: 18312, manufacturer_sku: pvx_sku[:manufacturer_sku]) }

  let(:existing_sku) do
    create(
      :base_sku, :sized, :with_product, :with_barcode,
      product: product,
      barcode: barcode,
      sku: pvx_sku[:sku],
      manufacturer_sku: pvx_sku[:manufacturer_sku],
      manufacturer_size: pvx_sku[:manufacturer_size],
      element: element,
      size: pvx_sku[:size],
      season: Season.first
    )
  end

  let(:new_sku_attrs) do
    {
      sku: '1234-UK-7',
      manufacturer_sku: existing_sku.manufacturer_sku,
      manufacturer_color: existing_sku.manufacturer_color,
      manufacturer_size:  existing_sku.manufacturer_size,
      vendor_id:  existing_sku.vendor_id,
      product_name:  existing_sku.product_name,
      season:  'new season',
      color:  existing_sku.color,
      size:  'UK-7',
      lead_gender: 'M',
      barcode: existing_sku.barcodes.first.barcode,
      color_family:  existing_sku.color_family,
      size_scale:  existing_sku.size_scale,
      cost_price:  existing_sku.cost_price,
      list_price:  existing_sku.list_price,
      price:  existing_sku.price,
      inv_track: existing_sku.inv_track,
      gender:  existing_sku.gender,
      listing_genders:  existing_sku.listing_genders,
      category_id:  existing_sku.category_id,
      on_sale:  existing_sku.on_sale,
      category_name:  existing_sku.category_name,
      order_tool_reference: '1234321'
    }
  end
end
