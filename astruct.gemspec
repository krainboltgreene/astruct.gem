#!/usr/bin/env ruby

lib = File.expand_path(File.join("..", "lib"), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "astruct/version"

Gem::Specification.new do |spec|
  spec.name = "astruct"
  spec.version = AltStruct::VERSION
  spec.authors = ["Kurtis Rainbolt-Greene"]
  spec.email = ["me@kurtisrainboltgreene.name"]
  spec.summary = %q{A better version of OpenStruct}
  spec.description = spec.summary
  spec.homepage = "http://krainboltgreene.github.io/astruct.gem"
  spec.license = "MIT"

  spec.files = Dir[File.join("lib", "**", "*")]
  spec.executables = Dir[File.join("bin", "**", "*")].map! { |f| f.gsub(/bin\//, "") }
  spec.test_files = Dir[File.join("test", "**", "*"), File.join("spec", "**", "*")]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "pry", "~> 0.9"
  spec.add_development_dependency "pry-doc", "~> 0.6"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"
  spec.add_development_dependency "benchmark-ips", "~> 2.0"
  spec.add_development_dependency "ruby-prof", "~> 0.14"
end
