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
# 
# PLATFORM: rubinius 2.0.0rc1 (1.9.3 release 2012-11-02 JI) [x86_64-apple-darwin12.2.0]
# TIMESTAMP: 2012-11-05 10:15:21 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data then delete
#                              1 i/100ms
# AStruct new with data then delete
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then delete
#                             3.0 (±33.5%) i/s -         15 in   5.274702s
# AStruct new with data then delete
#                             2.9 (±0.0%) i/s -         14 in   5.064470s
