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
# Calculating -------------------------------------
# OStruct new with data then 3 deep and inspect 1 i/100ms
# AStruct new with data then 3 deep and inspect 1 i/100ms
# -------------------------------------------------
# OStruct new with data then 3 deep and inspect 2.0 (±0.0%) i/s - 10 in 5.184739s
# AStruct new with data then 3 deep and inspect 3.1 (±31.9%) i/s - 15 in 5.029310s
