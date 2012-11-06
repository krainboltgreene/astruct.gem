require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct new with data then delete" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.delete_field :item1
  end

  x.report "AStruct new with data then delete" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.delete :item1
  end
end
