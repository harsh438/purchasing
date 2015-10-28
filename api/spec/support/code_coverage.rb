if ENV['COVERAGE'] == 'on'
  require 'simplecov'
  SimpleCov.start 'rails'

  if ENV['COVERAGE_FORMAT'] == 'rcov'
    require 'simplecov-rcov'
    SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  end
end
