class PackingList < ActiveRecord::Base
  belongs_to :goods_received_notice
  has_attached_file :list

  validates_attachment_content_type :list, content_type: %w(image/jpeg
                                                            image/pjpeg
                                                            image/png
                                                            image/x-png
                                                            application/pdf
                                                            application/vnd.ms-excel,
                                                            application/msexcel,
                                                            application/x-msexcel,
                                                            application/x-ms-excel,
                                                            application/x-excel,
                                                            application/x-dos_ms_excel,
                                                            application/xls,
                                                            application/x-xls,
                                                            application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,
                                                            application/x-pdf
                                                            message/rfc822
                                                            text/html
                                                            message/rfc822 eml
                                                            application/msword
                                                            application/vnd.openxmlformats-officedocument.wordprocessingml.document
                                                            application/vnd.openxmlformats-officedocument.wordprocessingml.template
                                                            )
  def list_url
    list.expiring_url(300)
  end
end
