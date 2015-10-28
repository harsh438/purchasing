begin
  require 'tailor/rake_task'
  Tailor::RakeTask.new
rescue LoadError
end
