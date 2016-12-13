class BatchFileProcessor < ActiveRecord::Base
  self.primary_key = 'id'

  belongs_to :batch_file

  def self.available_processors
    uniq.where(available: true).pluck(:id, :processor_type).map do |id, processor_type|
      { id: id, name: processor_type }
    end
  end
end
