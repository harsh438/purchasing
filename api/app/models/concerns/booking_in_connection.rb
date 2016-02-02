module BookingInConnection
  extend ActiveSupport::Concern

  included do
    self.table_name = "#{Rails.configuration.database_configuration[Rails.env.to_s]['database']}.#{self.table_name}"
    establish_connection "bookingin_#{Rails.env}".to_sym
  end
end
