require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct load with data" do
    class OProfile < OpenStruct; end
    op = OProfile.new
    op.marshal_load DATA.dup
  end

  x.report "AStruct load with data" do
    class AProfile < AltStruct; end
    ap = AProfile.new
    ap.load DATA.dup
  end
end
# 
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:18:54 -0800
# ---
# Calculating -------------------------------------
# OStruct load with data
#                              1 i/100ms
# AStruct load with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct load with data
#                             5.3 (±37.6%) i/s -         26 in   5.143205s
# AStruct load with data
#                             5.3 (±18.8%) i/s -         26 in   5.086193s
