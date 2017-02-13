class MergeJobSerializer < ActiveModel::Serializer
  attributes :id,
             :from_internal_sku,
             :to_internal_sku,
             :barcode
end
