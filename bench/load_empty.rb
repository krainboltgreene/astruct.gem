require "benchmark/ips"
require "astruct"
require "ostruct"
require "securerandom"

DATA = (1..5_000).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)

Benchmark.ips do |x|
  x.report "OStruct" do
    class OProfile < OpenStruct; end
    op = OProfile.new
    op.marshal_load DATA.dup
  end

  x.report "AStruct" do
    class AProfile < AltStruct; end
    ap = AProfile.new
    ap.load DATA.dup
  end
end
