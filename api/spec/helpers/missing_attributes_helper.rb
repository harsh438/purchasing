module MissingAttributesHelper
  def missing_sku_id
    77
  end

  def path
    'spec/fixtures/files/missing_sku_attributes_builder/'
  end

  def setup
    create(:product, product_attrs)
    create(:language_category, catID: 69, name: 'Shoes')
    allow(Season).to receive(:find_by).and_return('AW16')
  end

  def unsized_attrs
    {
      sku_id: missing_sku_id,
      product_id: 44,
      option_id: 0,
      cost: 19.99,
      supplier_list_price: 20.0,
      product_rrp: 24.0,
      sell_price: 25.0,
      sent_to_peoplevox: 0,
      season: 'AW16',
      category_id: 69,
      gender: 'F',
      vendor_id: 27,
      product_name: 'A Long Weight',
      product_sku: 'VWWX-6RT',
      product_size: '',
      manufacturer_size: '',
      product_color: '6RT',
      order_tool_reference: 75524
    }
  end

  def sized_attrs
    unsized_attrs.merge({
      option_id: 88,
      product_size: 'S',
      manufacturer_size: 'XL',
    })
  end

  def product_attrs
    {
      id: 44,
      listing_genders: 'B G',
      color: 'Red',
      vendor: build_stubbed(:vendor, id: 42),
      on_sale: 'Y'
    }
  end
end
