require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct new with data then delete" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.delete_field :key1
  end

  x.report "AStruct new with data then delete" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.delete :key1
  end
end
# 
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:17:50 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data then delete
#                              1 i/100ms
# AStruct new with data then delete
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then delete
#                             4.4 (±22.5%) i/s -         22 in   5.028472s
# AStruct new with data then delete
#                             5.4 (±18.6%) i/s -         26 in   5.028498s
