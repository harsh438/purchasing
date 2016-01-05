if ENV['COVERAGE'] == 'on'
  require 'simplecov'

  if ENV['CIRCLE_ARTIFACTS']
    artifacts_dir = File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
    SimpleCov.coverage_dir(artifacts_dir)
  end

  SimpleCov.start 'rails'

  if ENV['COVERAGE_FORMAT'] == 'rcov'
    require 'simplecov-rcov'
    SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  end
end
