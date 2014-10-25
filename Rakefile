#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run all the tests in spec"
RSpec::Core::RakeTask.new(:spec)

desc "Running all the benchmarks and writing results to file"
task :benchmark do
  STDOUT.puts("Benchmarking:")
  Dir[File.join(File.dirname(__FILE__), "bench", "**", "*.rb")].each do |benchmark|
    STDOUT.puts("---")
    STDOUT.puts(`bundle exec ruby #{benchmark}`.gsub("\t", " ").gsub("---", ""))
  end
end

desc "Run all profiling tests"
task :profile do
  Dir[File.join(File.dirname(__FILE__), "prof", "**", "*.rb")].each do |profile|
    `bundle exec ruby #{profile}`
  end
end

desc "Note each result in a git-note"
task :record do
  `git notes add -f -m "\`bundle exec rake benchmark\`"`
end

desc "Compare current versus last commit"
task :compare do
  system "diff -u <(git notes show) <(bundle exec rake benchmark)"
end

desc "Default: run tests"
task default: :spec
