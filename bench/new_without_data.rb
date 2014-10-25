require "benchmark/ips"
require "ostruct"
require "astruct"

puts "ruby: #{`ruby -v`.chomp.inspect}"
puts "rubygems: #{`gem -v`.chomp.inspect}"
puts "rvm: #{`rvm -v`.chomp.inspect}"
puts "astruct: #{AltStruct::VERSION.inspect}"
puts "file: #{__FILE__.inspect}"
puts "result: |"

class OProfile < OpenStruct; end
class AProfile < AltStruct; end

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 3

  analysis.report("OStruct") do
    OProfile.new
  end

  analysis.report("AStruct") do
    AProfile.new
  end

  analysis.compare!
end
