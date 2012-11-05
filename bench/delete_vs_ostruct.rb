require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

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

# 2012-11-04 16:05:05 -0800
# Calculating -------------------------------------
# OStruct new with data then delete
#                              1 i/100ms
# AStruct new with data then delete
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then delete
#                             6.2 (±16.1%) i/s -         31 in   5.056709s
# AStruct new with data then delete
#                             7.4 (±27.0%) i/s -         36 in   5.049519s
