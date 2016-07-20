RSpec.describe Product do
  subject(:json)           { prod.as_json }
  let(:vendor)             { build(:vendor) }
  let(:barcode)            { prod.master_sku.barcodes.latest }
  let(:first_received)     { prod.pvx_ins.first.logged }
  let(:item_codes)         { prod.kit_managers.map(&:item_code) }
  let(:reporting_category) { prod.reporting_category }
  let(:prod)               { create(
                               :product,
                               :with_master_sku,
                               :with_reporting_category,
                               :with_pvx_in,
                               :with_kit_managers,
                               listing_genders: "M",
                               color: "blue",
                               dropshipment: "D-R-P",
                               sale_price: 2.99,
                               active: "Y",
                               cost: 2.99,
                               vendor: vendor,
                               product_images: build_list(:product_image, 2)
                             )
  }

  describe "#as_json" do
    context "When the product is sized" do
      before do
        prod.skus += build_list(:sku, 2, vendor: prod.vendor)
      end

      it "Parent" do
        expect(json).to include(
          id: prod.id,
          sku: prod.id,
          price: prod.price,
          sale_price: prod.sale_price,
          active: prod.active,
          use_legacy_slug: true,
          barcode: barcode.barcode,
          cost_price: prod.cost,
          dropshipment: prod.dropshipment,
          brand: vendor.name,
        )
      end

      it "Properties" do
        expect(json[:properties]).to include gender: prod.listing_genders
        expect(json[:properties]).to include colour: prod.color
      end

      it "Children" do
        expect(json[:children]).to include(
          sku: prod.skus.first.sku,
          barcode: prod.skus.first.barcodes.first.barcode,
          price: prod.skus.first.price,
          cost_price: prod.skus.first.cost_price,
          legacy_brand_size: prod.skus.first.manufacturer_size,
          options: { size: prod.skus.first.size }
        )
      end

      it "Images" do
        allow_any_instance_of(ProductImageSerializer).to receive(:as_json)
          .and_return("IMAGES!")
        expect(json[:images]).to eq [ "IMAGES!", "IMAGES!" ]
      end

      it "Legacy Information" do
        expect(json).to include(
          legacy_lead_gender: prod.master_sku.gender,
          legacy_season: prod.master_sku.season,
          legacy_reporting_category: reporting_category.catid,
          legacy_supplier_sku: prod.manufacturer_sku,
          legacy_reporting_category_name: prod.master_sku.language_category.catName,
          legacy_more_from_category: prod.master_sku.ordered_category_id,
          legacy_first_received_at: first_received
        )
      end

      it "Parts" do
        expect(json).to include(
          parts: item_codes
        )
      end

      describe "Contents:" do
        before { create(:french_language_product, product: prod) }
        let(:english)          { prod.language_products.first }
        let(:french)           { prod.language_products[1] }
        let(:english_contents) { json[:contents][0] }
        let(:french_contents)  { json[:contents][1] }


        it "Eng lang" do
          expect(english_contents[:lang]).to eq 'en'
        end

        it "Fr lang" do
          expect(french_contents[:lang]).to eq 'fr'
        end

        context "Content key's value contains.... " do
          it "a name and teaser" do
            expect(english_contents[:content]).to include(
              name: english.name,
              teaser: english.teaser
            )
            expect(french_contents[:content]).to include(
              name: french.name,
              teaser: french.teaser
            )
          end

          context "a legacy_slug which..." do
            it "downcases a name" do
              expect(english_contents[:content][:legacy_slug]).to eq english_contents[:content][:legacy_slug].downcase
            end

            it "replaces spaces with -" do
              expect(english_contents[:content][:legacy_slug].match(/\s/)).to be nil
            end

            it "replaces ' with nothing" do
              expect(english_contents[:content][:legacy_slug].match(/'/)).to be nil
            end

            it "adds a pid to the end" do
              expect(english_contents[:content][:legacy_slug]).to include "#{prod.id}"
            end
          end
        end
      end

      it "Options" do
        expect(json[:options]).to eq ["Size"]
      end
    end

    context "Product is not sized; No children" do
      it "the children key maps to an empty array" do
        expect(json[:children]).to eq []
      end

      it "the options key maps to an empty array" do
        expect(json[:options]).to eq []
      end
    end
  end
end
