class MergeJob < ActiveRecord::Base
  def self.pending_jobs(last_imported_id, limit_count, last_import_timestamp)
    where(completed_at: nil)
    .where('(updated_at > :timestamp) OR (updated_at = :timestamp AND id > :id)', {
      timestamp: last_import_timestamp,
      id: last_imported_id
    })
    .order('merge_jobs.updated_at ASC, merge_jobs.id ASC')
    .limit(limit_count)
  end
end
