require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct dump with data" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.marshal_dump
  end

  x.report "AStruct dump with data" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.dump
  end
end
# 
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:18:06 -0800
# ---
# Calculating -------------------------------------
# OStruct dump with data
#                              1 i/100ms
# AStruct dump with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct dump with data
#                             4.6 (±21.6%) i/s -         23 in   5.176739s
# AStruct dump with data
#                             5.4 (±37.3%) i/s -         26 in   5.200824s
