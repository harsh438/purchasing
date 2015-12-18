module BookingInConnection
  extend ActiveSupport::Concern

  included do
    establish_connection "bookingin_#{Rails.env}"
  end
end
