module BookingInConnection
  extend ActiveSupport::Concern

  included do
    database = Rails.configuration.database_configuration["bookingin_#{Rails.env}"]['database']
    self.table_name = "#{database}.#{self.table_name}"
    establish_connection "bookingin_#{Rails.env}".to_sym
  end
end
