class BatchFileLineValidateWorker
  include Sidekiq::Worker

  def perform(line_id)
    batch_file_line = BatchFileLine.find(line_id)

    batch_file_line.validate_line
    batch_file_line.batch_file.attempt_send_process_validate_email
  end
end
