require 'benchmark/ips'
require_relative '../lib/astruct'
require 'ostruct'

DATA = (1..1_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct load" do
    class OProfile < OpenStruct; end
    op = OProfile.new
    op.marshal_load DATA.dup
  end

  x.report "AStruct load" do
    class AProfile < AltStruct; end
    ap = AProfile.new
    ap.load DATA.dup
  end
end
