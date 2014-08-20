#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run all the tests in spec"
RSpec::Core::RakeTask.new(:spec)

desc "Running all the benchmarks and writing results to file"
task :benchmark do
  STDOUT.puts("Benchmarking:")
  Dir[File.join(File.dirname(__FILE__), "bench", "**", "*.rb")].each do |benchmark|
    STDOUT.puts <<-DOCUMENT
---
file: #{benchmark}
platform: #{RUBY_DESCRIPTION}
timestamp: #{Time.now}
results: |
#{`bundle exec ruby #{benchmark}`.split("-------------------------------------------------").last}
DOCUMENT
  end unless ENV["CI"]
end

desc "Run all profiling tests"
task :profile do
  Dir[File.join(File.dirname(__FILE__), "prof", "**", "*.rb")].each do |profile|
    `bundle exec ruby #{profile}`
  end
end

desc "Note each result in a git-note"
task :record do
  `git notes add -f -m "#{`bundle exec rake benchmark`}"`
end

desc "Compare current versus last commit"
task :compare do
  system "diff -u <(git notes show) <(bundle exec rake benchmark)"
end

desc "Default: run tests"
task default: :spec
