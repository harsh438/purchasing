require 'json_logger'


Purchasing::Application.config.json_logger = JsonLogger.new('log/purchasing.json.log')
