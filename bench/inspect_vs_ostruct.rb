require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct inspect with data" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.inspect
  end

  x.report "AStruct inspect with data" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.inspect
  end
end
# 
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:18:38 -0800
# ---
# Calculating -------------------------------------
# OStruct inspect with data
#                              1 i/100ms
# AStruct inspect with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct inspect with data
#                             4.4 (±22.5%) i/s -         22 in   5.063692s
# AStruct inspect with data
#                             4.9 (±20.2%) i/s -         25 in   5.229125s
