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
# Calculating -------------------------------------
# OStruct new with data then delete 1 i/100ms
# AStruct new with data then delete 1 i/100ms
# -------------------------------------------------
# OStruct new with data then delete 8.9 (±11.3%) i/s - 44 in 5.014542s
# AStruct new with data then delete 10.2 (±29.5%) i/s - 48 in 5.014586s
