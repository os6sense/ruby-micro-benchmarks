desc 'perform a run of the benchmark, storing the results in the db'
task :benchmark_run => :environment do
  require_relative '../../benchmarks'
  run_benchmarks
end
