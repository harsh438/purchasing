desc 'Run Brakeman'
task :brakeman do
  require 'brakeman'
  Brakeman.run(app_path: '.', print_report: true)
end

namespace :build do
  desc 'Run Brakeman for build env'
  task :brakeman do
    require 'brakeman'
    system 'mkdir -p report/'
    Brakeman.run(app_path: '.',
                 output_formats: [:to_tabs],
                 output_files: ['report/brakeman-output.tabs'])
  end
end
