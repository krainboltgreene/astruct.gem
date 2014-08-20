require "benchmark/ips"
require "ostruct"
require "astruct"
require "securerandom"

Benchmark.ips do |x|
  x.report "OStruct" do
    class OProfile < OpenStruct; end
    OProfile.new
  end

  x.report "AStruct" do
    class AProfile < AltStruct; end
    AProfile.new
  end
end
