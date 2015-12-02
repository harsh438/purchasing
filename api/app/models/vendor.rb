class Vendor < ActiveRecord::Base
  self.table_name = :ds_vendors

  include LegacyMappings
  include Searchable

  def self.relevant
    where('venID in (select distinct orderTool_venId from purchase_orders)')
  end

  scope :latest, -> { order(id: :desc) }

  has_many :supplier_vendors, foreign_key: :BrandID, class_name: 'SupplierVendor'
  has_many :suppliers, through: :supplier_vendors

  has_one :details, class_name: 'VendorDetail'
  accepts_nested_attributes_for :details


  map_attributes id: :venID,
                 name: :venCompany

  paginates_per 50

  def details
    super || build_details
  end

  def as_json(options = {})
    details.as_json.merge(super).tap do |vendor|
      vendor['created_at'] = vendor['created_at'].to_s
      vendor['updated_at'] = vendor['updated_at'].to_s
    end
  end
end
