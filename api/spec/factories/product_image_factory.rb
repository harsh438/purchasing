FactoryGirl.define do
  factory :product_image do
    id 1
    product_id 420420
    position 2
    width 1200
    height 1200
    md5 nil
    import_batch_id 0
    source_path 'somewhere/at/something/pic.jpg'
    its_reference 'magic@lstringofdoom'
    created_at '2016-07-01'
    updated_at '2016-07-02'
    uploaded_s3_at '2016-07-03'
    uploaded_its_at '2016-07-04'
    uploaded_san_at '2016-07-05'
    deleted_at '2016-07-06'
    accepted_at '2016-07-07'
    legacy_position 'b'
  end
end
