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

# 2012-11-04 16:05:50 -0800
# Calculating -------------------------------------
# OStruct inspect with data
#                              1 i/100ms
# AStruct inspect with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct inspect with data
#                             4.9 (±20.6%) i/s -         24 in   5.003597s
# AStruct inspect with data
#                             6.1 (±16.3%) i/s -         30 in   5.001051s
# 
# PLATFORM: rubinius 2.0.0rc1 (1.9.3 release 2012-11-02 JI) [x86_64-apple-darwin12.2.0]
# TIMESTAMP: 2012-11-05 10:16:10 -0800
# ---
# Calculating -------------------------------------
# OStruct inspect with data
#                              1 i/100ms
# AStruct inspect with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct inspect with data
#                             2.6 (±37.8%) i/s -         13 in   5.224828s
# AStruct inspect with data
#                             2.7 (±0.0%) i/s -         13 in   5.023490s
