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
# 
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:19:10 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data then 3 deep and inspect
#                              1 i/100ms
# AStruct new with data then 3 deep and inspect
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then 3 deep and inspect
#                             1.3 (±0.0%) i/s -          7 in   5.560086s
# AStruct new with data then 3 deep and inspect
#                             1.6 (±0.0%) i/s -          9 in   5.569932s
