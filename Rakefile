#!/usr/bin/env ruby
require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => error
  $stderr.puts error.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit error.status_code
end

Bundler::GemHelper.install_tasks

desc "Run all of the tests"
Rake::TestTask.new do |config|
  config.libs << 'test'
  config.pattern = 'test/**/*_test*'
  config.verbose = true
  config.warning = true
end

desc "Generate all of the docs"
YARD::Rake::YardocTask.new do |config|
  config.files = Dir['lib/**/*.rb']
end

desc "Running all the benchmarks and writing results to file"
task :bench do
  Dir[File.join(File.dirname(__FILE__), "bench", "*")].each do |benchmark|
    header = "\nPLATFORM: #{RUBY_DESCRIPTION}\nTIMESTAMP: #{Time.now}\n---\n"
    results = `bundle exec ruby #{benchmark}`
    document = header + results
    File.open benchmark, "a" do |file|
      file.write document.gsub /^/, "# "
    end
  end
end

desc 'Default: run tests, and generate docs'
task :default => [ :test, :yard ]
