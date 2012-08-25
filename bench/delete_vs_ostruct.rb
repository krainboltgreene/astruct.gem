require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct load" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.delete_field :item1
  end

  x.report "AStruct load" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.delete :item1
  end
end
