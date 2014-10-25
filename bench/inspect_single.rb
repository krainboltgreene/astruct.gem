require "benchmark/ips"
require "ostruct"
require "astruct"
require "securerandom"

puts "ruby: #{`ruby -v`.chomp.inspect}"
puts "rubygems: #{`gem -v`.chomp.inspect}"
puts "rvm: #{`rvm -v`.chomp.inspect}"
puts "astruct: #{AltStruct::VERSION.inspect}"
puts "file: #{__FILE__.inspect}"
puts "result: |"

DATA = (1..50).map { { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)

class AProfile < AltStruct; end
class OProfile < OpenStruct; end

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 3

  analysis.report "OStruct" do
    op = OProfile.new(DATA.dup)
    op.inspect
  end

  analysis.report "AStruct" do
    ap = AProfile.new(DATA.dup)
    ap.inspect
  end

  analysis.compare!
end
