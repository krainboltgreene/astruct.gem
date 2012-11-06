require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!
DATA2 = (10_000..20_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct new with data then load with more data" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.marshal_load op.marshal_dump.merge DATA2.dup
  end

  x.report "AStruct new with data then load with more data" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.load DATA2.dup
  end
end
# Calculating -------------------------------------
# OStruct new with data then load with more data 1 i/100ms
# AStruct new with data then load with more data 1 i/100ms
# -------------------------------------------------
# OStruct new with data then load with more data 2.6 (±0.0%) i/s - 13 in 5.025779s
# AStruct new with data then load with more data 3.7 (±26.8%) i/s - 19 in 5.184870s
