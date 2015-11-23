class Supplier < ActiveRecord::Base
  include LegacyMappings
  include Searchable

  has_many :supplier_vendors, foreign_key: :SupplierID, class_name: 'SupplierVendor'
  has_many :vendors, through: :supplier_vendors
  has_one :details, class_name: 'SupplierDetail'

  after_initialize :ensure_details

  map_attributes id: :SupplierID,
                 name: :SupplierName

  def self.relevant
    joins('inner join suppliers_to_brands sb on suppliers.SupplierID = sb.SupplierID')
      .where('sb.BrandID in (select distinct orderTool_venId from purchase_orders)')
      .uniq
  end

  def self.alphabetical
    order(name: :asc)
  end

  private

  def ensure_details
    self.details || self.build_details
  end
end
