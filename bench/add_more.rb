require "benchmark/ips"
require "astruct"
require "ostruct"
require "securerandom"

DATA = (1..5_000).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)
DATA2 = (5_000..10_000).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)

Benchmark.ips do |x|
  x.report "OStruct" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.marshal_load op.marshal_dump.merge DATA2.dup
  end

  x.report "AStruct" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.load DATA2.dup
  end
end
