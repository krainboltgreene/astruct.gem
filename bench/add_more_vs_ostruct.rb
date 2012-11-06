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
# 
# PLATFORM: rubinius 2.0.0rc1 (1.9.3 release 2012-11-02 JI) [x86_64-apple-darwin12.2.0]
# TIMESTAMP: 2012-11-05 10:15:01 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data then load with more data
#                              1 i/100ms
# AStruct new with data then load with more data
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then load with more data
#                             1.2 (±0.0%) i/s -          7 in   5.791506s
# AStruct new with data then load with more data
#                             1.2 (±0.0%) i/s -          7 in   5.803301s
