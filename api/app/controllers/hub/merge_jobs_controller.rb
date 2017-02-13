class Hub::MergeJobsController < ApplicationController
  def latest
    last_id, limit, last_ts = latest_params.values_at(
      :last_imported_id, :import_size, :last_imported_timestamp,
    )

    last_ts = Time.zone.parse(last_ts) if last_ts.present?

    merge_jobs = MergeJob.pending_jobs(last_id, limit, last_ts)
    render json: create_hub_object(merge_jobs, last_ts, last_id)
  end

  def completed
    id, timestamp = completed_params.values_at(:id, :completed_at)

    timestamp = Time.zone.parse(timestamp)

    merge_job = MergeJob.find_by(id: id)
    merge_job.update_attributes!(completed_at: timestamp)

    render json: {
      request_id: request_id,
      summary: "merge_job #{id} has been marked as complete"
    }
  end

  private

  def latest_params
    params.require(:parameters).permit(
      :last_imported_id, :import_size, :last_imported_timestamp
    )
  end

  def completed_params
    params.require(:merge_job).permit(:id, :completed_at)
  end

  def request_id
    params.require(:request_id)
  end

  def create_hub_object(merge_jobs, last_timestamp, last_id)
    {
      request_id: request_id,
      summary: "Returned #{merge_jobs.length} merge_jobs.",
      merge_jobs: ActiveModel::ArraySerializer.new(
        merge_jobs,
        each_serializer: MergeJobSerializer
      ),
      parameters: {
        last_imported_timestamp: merge_jobs.last.try(:updated_at) || last_timestamp,
        last_imported_id: merge_jobs.last.try(:id) || last_id
      }
    }
  end
end
