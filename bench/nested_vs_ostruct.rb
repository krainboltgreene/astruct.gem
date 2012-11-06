require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct new with data then 3 deep and inspect" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.op2 = OProfile.new DATA.dup
    op.op2.op3 = OProfile.new DATA.dup
    op.inspect
  end

  x.report "AStruct new with data then 3 deep and inspect" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.ap2 = AProfile.new DATA.dup
    ap.ap2.ap3 = AProfile.new DATA.dup
    ap.inspect
  end
end

# 2012-11-04 16:06:22 -0800
# Calculating -------------------------------------
# OStruct new with data then 3 deep and inspect
#                              1 i/100ms
# AStruct new with data then 3 deep and inspect
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then 3 deep and inspect
#                             1.1 (±0.0%) i/s -          6 in   5.686992s
# AStruct new with data then 3 deep and inspect
#                             1.5 (±0.0%) i/s -          8 in   5.306089s
# 
# PLATFORM: rubinius 2.0.0rc1 (1.9.3 release 2012-11-02 JI) [x86_64-apple-darwin12.2.0]
# TIMESTAMP: 2012-11-05 10:16:44 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data then 3 deep and inspect
#                              1 i/100ms
# AStruct new with data then 3 deep and inspect
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then 3 deep and inspect
#                             0.7 (±0.0%) i/s -          4 in   5.882182s
# AStruct new with data then 3 deep and inspect
#                             0.7 (±0.0%) i/s -          4 in   5.806138s
