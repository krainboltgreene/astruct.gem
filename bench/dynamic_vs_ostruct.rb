require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct new with data then assign new data" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.example1 = "red"
    op.example2 = "blue"
    op.example3 = "green"
  end

  x.report "AStructt new with data then assign new data" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.example1 = "red"
    ap.example2 = "blue"
    ap.example3 = "green"
  end
end
# 
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:18:22 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data then assign new data
#                              1 i/100ms
# AStructt new with data then assign new data
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then assign new data
#                             4.2 (±23.8%) i/s -         21 in   5.200944s
# AStructt new with data then assign new data
#                             5.1 (±38.9%) i/s -         24 in   5.001440s
