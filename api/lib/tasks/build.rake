desc 'Build application'
task build: ['build:env',
             :cane,
             :tailor,
             'db:test:prepare',
             'db:seed',
             'build:brakeman',
             'build:spec',
             'log:clear']

namespace :build do
  task :env do
    ENV['RAILS_ENV'] = 'test'
    ENV['COVERAGE'] = 'on'
    ENV['COVERAGE_FORMAT'] = 'rcov'
  end
end
