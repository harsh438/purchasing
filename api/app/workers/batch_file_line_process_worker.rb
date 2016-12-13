class BatchFileLineProcessWorker
  include Sidekiq::Worker

  def perform(batch_file_line_id)
    batch_file_line = BatchFileLine.find(batch_file_line_id)
    batch_file_line.process
  end
end
