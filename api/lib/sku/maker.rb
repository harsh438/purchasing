class Sku::Maker
  def initialize(sized_attrs:, unsized_attrs:)
    @sized_attrs = sized_attrs
    @unsized_attrs = unsized_attrs
    @missing_sku_id = unsized_attrs.missing_sku_id
  end

  def create_or_update_references
    if existing_sku.present?
      begin
        Barcode.where(sku_id: missing_sku_id).each do |record|
          record.update_attributes!(sku_id: existing_sku.id)
        end
        PurchaseOrderLineItem.where(sku_id: missing_sku_id).each do |line|
          line.update_attributes!(sku_id: existing_sku.id)
        end
      rescue ActiveRecord::RecordInvalid
        puts 'Nothing updated; sku that exists probably has a null barcode.'
      end
    else
      begin
        Sku.create!(retrieved_attributes)
      rescue ActiveRecord::RecordInvalid
        puts 'some of the following attributes were invalid:'
        puts retrieved_attributes
      end
    end
  end

  private

  attr_reader :sized_attrs, :unsized_attrs, :missing_sku_id

  def retrieved_attributes
    if missing_sku_is_sized?
      sized_attrs.retrieve_attributes.with_indifferent_access
    else
      unsized_attrs.retrieve_attributes.with_indifferent_access
    end
  end

  def existing_sku
    Sku.find_by(sku: retrieved_attributes[:sku], season: retrieved_attributes[:season].nickname)
  end

  def missing_sku_is_sized?
    PurchaseOrderLineItem.find_by(sku_id: missing_sku_id).product_sized?
  end
end
