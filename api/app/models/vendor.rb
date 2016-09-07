class Vendor < ActiveRecord::Base
  database = Rails.configuration.database_configuration[Rails.env.to_s]['database']
  self.table_name = "#{database}.ds_vendors"

  include LegacyMappings
  include Searchable

  scope :latest, -> { order(id: :desc) }

  has_many :supplier_vendors, foreign_key: :BrandID, class_name: 'SupplierVendor'
  has_many :suppliers, through: :supplier_vendors

  has_one :details, class_name: 'VendorDetail'
  accepts_nested_attributes_for :details
  has_many :products, foreign_key: :venID

  map_attributes id: :venID,
                 name: :venCompany

  paginates_per 50

  def self.updated_since(timestamp, max_id)
    if timestamp.nil?
      where('(updated_at is null) and venID > ?', max_id)
    else
      where('(updated_at = ? and venID > ?) or (updated_at > ?)', timestamp, max_id, timestamp)
    end
  end

  def self.not_sent_in_peoplevox
    where({ sent_in_peoplevox: nil })
  end

  def details
    super || build_details
  end

  def as_json(options = {})
    super.tap do |vendor|
      vendor['created_at'] = vendor['created_at'].to_s
      vendor['updated_at'] = vendor['updated_at'].to_s
    end
  end

  def as_json_with_details_and_suppliers
    details.as_json.merge(as_json).tap do |vendor|
      vendor['suppliers'] = suppliers.map(&:as_json)
    end
  end
end
