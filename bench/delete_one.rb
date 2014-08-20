require "benchmark/ips"
require "ostruct"
require "astruct"
require "securerandom"

DATA = (1..5_000).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)
KEY = DATA.keys.sample

Benchmark.ips do |x|
  x.report "OStruct" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.delete_field KEY
  end

  x.report "AStruct" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.delete KEY
  end
end
