require "benchmark/ips"
require "astruct"
require "ostruct"
require "securerandom"

DATA = (1..5_000).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)

Benchmark.ips do |x|
  x.report "OStruct" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.example1 = "red"
    op.example2 = "blue"
    op.example3 = "green"
  end

  x.report "AStructt" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.example1 = "red"
    ap.example2 = "blue"
    ap.example3 = "green"
  end
end
