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
# 
# PLATFORM: rubinius 2.0.0rc1 (1.9.3 release 2012-11-02 JI) [x86_64-apple-darwin12.2.0]
# TIMESTAMP: 2012-11-05 10:15:37 -0800
# ---
# Calculating -------------------------------------
# OStruct dump with data
#                              1 i/100ms
# AStruct dump with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct dump with data
#                             2.8 (±35.8%) i/s -         14 in   5.198971s
# AStruct dump with data
#                             2.8 (±0.0%) i/s -         14 in   5.073265s
