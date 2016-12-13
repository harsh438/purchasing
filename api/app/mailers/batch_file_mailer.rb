class BatchFileMailer < ActionMailer::Base
  def validating_complete(batch_file)
    batch_file_email(batch_file.id, 'validating batch file is complete')
  end

  def processing_complete(batch_file)
    batch_file_email(batch_file.id, 'processing batch file is complete')
  end

  def batch_file_email(batch_file_id, subject)
    @batch_file = BatchFile.find(batch_file_id)

    mail(
      to: @batch_file.user.email,
      from: "no-reply@surfdome.com",
      subject: subject
    )
  end
end
