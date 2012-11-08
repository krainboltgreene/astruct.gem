require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!
UPDATE = DATA.merge (1..5_000).map { |i| { "key#{i}" => "value#{i + rand(1..3)}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct partial updates with data" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.marshal_load op.marshal_dump.merge UPDATE.dup
  end

  x.report "AStruct partial updates with data" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.load UPDATE.dup
  end
end
#
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:19:44 -0800
# ---
# Calculating -------------------------------------
# OStruct partial updates with data
#                              1 i/100ms
# AStruct partial updates with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct partial updates with data
#                             3.4 (±29.5%) i/s -         17 in   5.211254s
# AStruct partial updates with data
#                             3.0 (±0.0%) i/s -         15 in   5.116449s
