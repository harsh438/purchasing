desc 'Build application'
task build: ['build:env',
             :cane,
             :tailor,
             'db:test:prepare',
             'build:brakeman',
             'build:spec',
             'log:clear']

namespace :build do
  task :env do
    ENV['RAILS_ENV'] = 'test'
    ENV['COVERAGE'] = 'on'
    ENV['COVERAGE_FORMAT'] = 'rcov'
    ENV['CODECLIMATE_REPO_TOKEN'] = 'acb163527f1b1b3f5b55750f8393e6e14e471ce16220b48a0b53ea28322da61c'
  end
end
