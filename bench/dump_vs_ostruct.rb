require 'benchmark/ips'
require_relative '../lib/astruct'
require 'ostruct'

DATA = (1..1_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct load" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.marshal_dump
  end

  x.report "AStruct load" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.dump
  end
end

class OProfile < OpenStruct; end
op = OProfile.new DATA.dup
class AProfile < AltStruct; end
ap = AProfile.new DATA.dup
puts "The output of each is the same: #{ap.dump == op.marshal_dump}"
