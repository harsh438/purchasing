describe ProductMigrator do
  context 'it should correctly migrate products to the skus table' do
    context 'create a record in the sku table for each combination of product options' do
      before do
        @first_product = create(:product)
        @second_product = create(:product)
        subject.migrate
      end

      it 'should correctly link the product_id' do
        expect(Sku.first.product_id).to eq(@first_product.id)
      end

      it 'should correctly link the lanage_product_id' do
        expect(Sku.first.language_product_id).to eq(@first_product.language_product.id)
      end

      it 'should correctly link the element_id' do
        expect(Sku.first.element_id).to eq(@first_product.language_product_options.first.element_id)
      end

      it 'should create the correct number of sku records' do
        expect(Sku.all.count).to eq(2)
      end
    end
  end
end