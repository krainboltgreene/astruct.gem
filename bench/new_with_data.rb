require "benchmark/ips"
require "astruct"
require "ostruct"
require "securerandom"

DATA = (1..5_000).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)

Benchmark.ips do |x|
  x.report "OStruct" do
    class OProfile < OpenStruct; end
    OProfile.new DATA.dup
  end

  x.report "AStruct" do
    class AProfile < AltStruct; end
    AProfile.new DATA.dup
  end
end
