require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct inspect with data" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.inspect
  end

  x.report "AStruct inspect with data" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.inspect
  end
end
