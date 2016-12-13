module BatchFileHelper
  def validate_batch_file(batch_file)
    batch_file.validate!
    BatchFileLineValidateWorker.drain
  end

  def process_batch_file(batch_file)
    batch_file.process!
    BatchFileLineProcessWorker.drain
  end

  def validate_and_process(batch_file)
    validate_batch_file(batch_file)
    process_batch_file(batch_file)
  end
end
