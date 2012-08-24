require 'benchmark/ips'
require_relative '../lib/astruct'
require 'ostruct'

DATA = (1..100).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct load" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.op2 = OProfile.new DATA.dup
    op.op2.op3 = OProfile.new DATA.dup
    op.inspect
  end

  x.report "AStruct load" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.ap2 = AProfile.new DATA.dup
    ap.ap2.ap3 = AProfile.new DATA.dup
    ap.inspect
  end
end

op = OProfile.new DATA.dup
op.op2 = OProfile.new DATA.dup
op.op2.op3 = OProfile.new DATA.dup
ap = AProfile.new DATA.dup
ap.ap2 = AProfile.new DATA.dup
ap.ap2.ap3 = AProfile.new DATA.dup
p ap.inspect
p op.inspect
puts "The output of each is the same: #{ap.inspect == op.inspect}"

