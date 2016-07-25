begin
  require 'cane/rake_task'

  desc 'Run cane to check quality metrics'
  Cane::RakeTask.new(:cane) do |cane|
    cane.abc_max = 20
    cane.style_measure = 130
    cane.no_readme = true
    cane.no_doc = true
    cane.abc_glob = '{app,lib,config}/**/*.rb'
    cane.abc_exclude = %w()
    cane.max_violations = 0
  end
rescue LoadError
end
