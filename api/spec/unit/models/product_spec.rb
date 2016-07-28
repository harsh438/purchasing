RSpec.describe Product do
  describe '#latest_season_skus' do
    let(:product) { create(:product) }
    let(:latest_season) { Season.first }
    let(:earliest_season) { Season.last }
    let!(:latest_sku) { create(:sku, season: latest_season, product: product) }

    before { create_list(:sku, 3, season: earliest_season, product: product) }

    it 'only returns skus in the most recent season' do
      expect(product.latest_season_skus).to include(latest_sku)
      expect(product.latest_season_skus.count).to eq(1)
    end
  end

  describe '#has_ugly_shipping_category?' do
    subject(:product) { create(:product) }
    before { product.product_categories.create(category: category) }

    {
      'Surfboards' => 480,
      'Snowboards' => 462,
      'Wakeboards' => 546,
      'Snow Skis'  => 784,
      'Longboards' => 761,
      'Stand Up Paddle Boards' => 780,
      'Bodyboards' => 486,
      'Kayaking'   => 635,
      'Snowboard Bags' => 463,
      'Skimboards' => 596,
      'Waterskis'  => 742,
    }.each do |category_name, category_id|
      context "when the product is a #{category_name.inspect}" do
        let(:category) { create(:category, name: category_name, id: category_id) }

        it 'then it returns true' do
          expect(product).to have_ugly_shipping_category
        end
      end
    end

    context 'when the product is in any other category' do
      let(:category) { create(:category, name: 'Other') }

      it 'then it returns false' do
        expect(product).to_not have_ugly_shipping_category
      end
    end
  end

  describe '#lead_gender' do
    subject { described_class.new(listing_genders: 'M W') }

    it 'uses the gender mapper' do
      allow(Gender).to receive(:string_from).and_return('Gorrilla')
      expect(subject.lead_gender).to eq(%w(Gorrilla))
    end

    context 'given multiple listing genders' do
      subject { described_class.new(listing_genders: 'U K T E I') }
      it 'only unique results are returned' do
        expect(subject.lead_gender).to eq([
          'Unisex', 'Kids', 'Toddler', 'Infant Boy', 'Infant'
        ])
      end
    end
  end

  describe '#related' do
    let(:color_a) { Faker::Color.color_name }
    let(:color_b) { Faker::Color.color_name }
    let(:product_name) { Faker::Commerce.product_name }
    let(:vendor) { create(:vendor) }
    let!(:related_product) do
      create(
        :product,
        color: color_b,
        vendor: vendor,
        name: [vendor.name, product_name, color_b].join(' - '),
      )
    end

    subject!(:product) do
      create(
        :product,
        color: color_a,
        vendor: vendor,
        name: [vendor.name, product_name, color_a].join(' - '),
      )
    end

    # throw in some other products
    before do
      create(
        :product,
        vendor: vendor,
        listing_genders: 'M',
        name: [vendor.name, product_name, color_b].join(' - '),
      )

      create(
        :product,
        vendor: vendor,
        photo_width: 0,
        name: [vendor.name, product_name, color_b].join(' - '),
      )

      create(
        :product,
        vendor: vendor,
        active: 'N',
        name: [vendor.name, product_name, color_b].join(' - '),
      )

      create(:product)
    end

    it 'returns the related product' do
      expect(product.related.pluck(:id)).to eq([related_product.id])
    end
  end

  describe '#as_json' do
    subject(:json) { product.as_json }

    let(:vendor) { create(:vendor) }

    let(:product) do
      create(
        :product,

        :with_reporting_category,
        :with_pvx_in,
        :with_kit_managers,
        :with_skus,

        listing_genders: 'M',
        color: 'blue',
        dropshipment: 'D-R-P',
        sale_price: 2.99,
        active: 'Y',
        cost: 2.99,
        vendor: vendor,
        name: [vendor.name, 'Awesome Co', 'blue'].join(' - '),
        product_images: build_list(:product_image, 2)
      )
    end

    context 'When the product is sized' do
      let!(:related_products) do
        create_list(
          :product,
          2,
          listing_genders: 'M',
          color: 'green',
          name: [vendor.name, 'Awesome Co', 'green'].join(' - '),
          dropshipment: 'D-R-P',
          sale_price: 2.99,
          active: 'Y',
          cost: 2.99,
          vendor: vendor,
          product_images: build_list(:product_image, 2)
        )
      end

      before do
        [
          [ChildSerializer, 'CHILD'],
          [ProductImageSerializer, 'IMAGE'],
          [ContentSerializer, 'CONTENT'],
        ].each do |(serializer, sub)|
          allow_any_instance_of(serializer).to receive(:as_json)
            .and_return(sub)
        end
      end

      it 'has the necessary attributes' do
        {
          id: product.id,
          sku: product.id,
          price: product.price,
          sale_price: product.sale_price,
          active: product.active,
          use_legacy_slug: true,
          barcode: product.barcodes.latest.first.barcode,
          cost_price: product.cost,
          dropshipment: true,
          brand: product.vendor.id,
          shipping_category: 'Default',
          properties: {
            'Gender' => product.listing_genders,
            'Colour' => product.color,
          },
          children: [
            'CHILD',
            'CHILD',
          ],
          images: [
            'IMAGE',
            'IMAGE',
          ],
          legacy_lead_gender: 'Men',
          legacy_season: product.season.nickname,
          legacy_reporting_category: product.reporting_category.category.id,
          legacy_supplier_sku: product.manufacturer_sku,
          legacy_reporting_category_name: product.reporting_category.category.language_categories.first.name,
          legacy_more_from_category: product.categories.first.id,
          legacy_first_received_at: product.pvx_ins.first.logged,
          contents: [
            'CONTENT',
          ],
          parts: product.kit_managers.map(&:item_code),
          related: related_products.map.with_index do |p, i|
            {
              sort_in_type: i + 1,
              product_id: p.id,
              type: 'also_bought',
            }
          end
        }.each do |key, value|
          expect(json).to include(key => value)
        end
      end
    end
  end
end
