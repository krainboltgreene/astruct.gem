require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct load with data" do
    class OProfile < OpenStruct; end
    op = OProfile.new
    op.marshal_load DATA.dup
  end

  x.report "AStruct load with data" do
    class AProfile < AltStruct; end
    ap = AProfile.new
    ap.load DATA.dup
  end
end

# 2012-11-04 16:06:05 -0800
# Calculating -------------------------------------
# OStruct load with data
#                              1 i/100ms
# AStruct load with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct load with data
#                             7.8 (±25.6%) i/s -         38 in   5.092898s
# AStruct load with data
#                             7.3 (±27.4%) i/s -         36 in   5.109352s
# 
# PLATFORM: rubinius 2.0.0rc1 (1.9.3 release 2012-11-02 JI) [x86_64-apple-darwin12.2.0]
# TIMESTAMP: 2012-11-05 10:16:27 -0800
# ---
# Calculating -------------------------------------
# OStruct load with data
#                              1 i/100ms
# AStruct load with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct load with data
#                             3.3 (±30.3%) i/s -         16 in   5.091012s
# AStruct load with data
#                             2.9 (±0.0%) i/s -         15 in   5.230703s
