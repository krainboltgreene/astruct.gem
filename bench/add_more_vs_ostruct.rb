require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!
DATA2 = (10_000..20_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct new with data then load with more data" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.marshal_load DATA2.dup
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
# OStruct new with data then load with more data 3.2 (±0.0%) i/s - 16 in 5.032341s
# AStruct new with data then load with more data 4.4 (±23.0%) i/s - 21 in 5.033214s

# 2012-11-04 16:04:50 -0800
# Calculating -------------------------------------
# OStruct new with data then load with more data
#                              1 i/100ms
# AStruct new with data then load with more data
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then load with more data
#                             2.8 (±0.0%) i/s -         14 in   5.071142s
# AStruct new with data then load with more data
#                             2.9 (±0.0%) i/s -         15 in   5.280918s
