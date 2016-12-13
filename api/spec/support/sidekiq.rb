require 'sidekiq/testing'

Sidekiq::Testing.fake!
Sidekiq::Logging.logger = nil
