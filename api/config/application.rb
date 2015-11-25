require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Purchasing
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << Rails.root.join('lib')

    config.http_auth = { enabled: true,
                         username: 'purchasing',
                         password: 'lastordersplease' }

    config.s3 = { access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                  destination: { key: ENV['DESTINATION_BUCKET_KEY'],
                                 region: ENV['DESTINATION_BUCKET_REGION'] } }

    config.paperclip_defaults = { s3_permissions: :private,
                                  s3_credentials: { bucket: ENV['DESTINATION_BUCKET_KEY'],
                                                    s3_host_name: "s3-#{ENV['DESTINATION_BUCKET_REGION']}.amazonaws.com",
                                                    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                                    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] } }
  end
end
