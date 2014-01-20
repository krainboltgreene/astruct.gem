require "benchmark/ips"
require "astruct"
require "ostruct"
require "securerandom"

DATA = (1..10_000).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)

Benchmark.ips do |x|
  x.report "OStruct" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.op2 = OProfile.new DATA.dup
    op.op2.op3 = OProfile.new DATA.dup
    op.inspect
  end

  x.report "AStruct" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.ap2 = AProfile.new DATA.dup
    ap.ap2.ap3 = AProfile.new DATA.dup
    ap.inspect
  end
end
