require 'benchmark/ips'
require_relative '../lib/astruct'
require 'ostruct'

DATA = (1..1_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct load" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.inspect
  end

  x.report "AStruct load" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.inspect
  end
end