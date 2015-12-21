module BookingInConnection
  extend ActiveSupport::Concern

  included do
    establish_connection "bookingin_#{Rails.env}".to_sym
  end
end
