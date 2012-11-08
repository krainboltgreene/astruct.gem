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
#
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:17:33 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data then load with more data
#                              1 i/100ms
# AStruct new with data then load with more data
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then load with more data
#                             1.8 (±0.0%) i/s -          9 in   5.186949s
# AStruct new with data then load with more data
#                             1.9 (±0.0%) i/s -         10 in   5.353544s
