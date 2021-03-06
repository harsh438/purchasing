Rails.application.configure do
  config.cache_classes = true
  config.paperclip_defaults[:storage] = :s3
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.logger = Logger.new(STDOUT)
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.paperclip_defaults = { storage: :s3,
                                s3_permissions: :private,
                                s3_credentials: { bucket: ENV['AWS_ASSET_BUCKET'],
                                                  s3_host_name: "s3-eu-west-1.amazonaws.com",
                                                  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                                  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] } }
  config.action_mailer.smtp_settings = {
    port: ENV['SMTP_PORT'].to_i,
    address: ENV['SMTP_HOST'],
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    domain: 'surfdome.io',
    enable_starttls_auto: true,
    authentication:'login',
  }
end
