require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Purchasing
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << Rails.root.join('lib')

    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => Rails.env.production? ? 'https://www.surfdome.io' : '*'
    }

    config.http_auth = { enabled: true,
                         username: 'purchasing',
                         password: 'lastordersplease' }

    config.pvx_credentials = { url: ENV['PVX_URL'],
                               key: ENV['PVX_KEY'],
                               token: ENV['PVX_TOKEN'] }

    config.paperclip_defaults = { s3_permissions: :private,
                                  s3_credentials: { bucket: ENV['AWS_ASSET_BUCKET'],
                                                    s3_host_name: "s3-eu-west-1.amazonaws.com",
                                                    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                                    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] } }

    config.surfdome = config_for(:surfdome_client)
  end
end
