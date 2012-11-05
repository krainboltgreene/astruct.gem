require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

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
# Calculating -------------------------------------
# OStruct dump with data 1 i/100ms
# AStruct dump with data 1 i/100ms
# -------------------------------------------------
# OStruct dump with data 9.0 (±22.2%) i/s - 44 in 5.055799s
# AStruct dump with data 10.2 (±29.4%) i/s - 48 in 5.073042s

# 2012-11-04 16:05:20 -0800
# Calculating -------------------------------------
# OStruct dump with data
#                              1 i/100ms
# AStruct dump with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct dump with data
#                             6.8 (±29.4%) i/s -         33 in   5.048132s
# AStruct dump with data
#                             7.7 (±26.0%) i/s -         37 in   5.086119s
