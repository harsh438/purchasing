desc 'batch run a given rake task for each line of a csv'
task :batch_run_rake_task, [:rake_task, :csv_file] => :environment do |_t, args|
  require 'csv'
  rake_task = args[:rake_task]
  csv_file = args[:csv_file]

  CSV.open(File.expand_path(csv_file)) do | rows |
    rows.each do | row |
      begin
        Rake::Task[rake_task.to_s].reenable
        Rake::Task[rake_task.to_s].invoke(*row)
      rescue SystemExit
        puts "#{row} failed"
      end
    end
  end
end
