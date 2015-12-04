describe ProductMigrator do
  context 'it should correctly migrate products to the skus table' do
    before do
      @first_product = create(:product)
      @second_product = create(:product)
    end

    it 'should create a record in the sku table for each combination of product options' do
      subject.migrate

      expect(Sku.first.product.id).to eq(@first_product.id)
    end
  end
end
