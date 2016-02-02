module BookingInConnection
  extend ActiveSupport::Concern

  included do
    establish_connection "bookingin_#{Rails.env}".to_sym
  end

  module ClassMethods
    def table_name_prefix
      database = Rails.configuration.database_configuration[Rails.env.to_s]['database']
      "#{database}."
    end
  end
end
