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

DATA = (1..50).map { |i| { "key#{i}" => SecureRandom.hex } }.inject :merge!
UPDATE = DATA.merge (1..25).map { |i| { "key#{i}" => SecureRandom.hex } }.inject :merge!

class OProfile < OpenStruct; end
class AProfile < AltStruct; end

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 3

  analysis.report "OStruct" do
    op = OProfile.new(DATA.dup)
    op.marshal_load(op.marshal_dump.merge(UPDATE.dup))
  end

  analysis.report "AStruct" do
    ap = AProfile.new(DATA.dup)
    ap.load(UPDATE.dup)
  end

  analysis.compare!
end
