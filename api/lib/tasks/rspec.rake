begin
  require 'rspec/core/rake_task'

  namespace :build do
    desc 'Run specs for build env (outputs for junit)'
    RSpec::Core::RakeTask.new(spec: 'build:env') do |t|
      t.rspec_opts = '--format progress --fail-fast --format RspecJunitFormatter --out report/TEST-unit.xml'
    end
  end
rescue LoadError
end
