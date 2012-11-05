require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

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
# Calculating -------------------------------------
# OStruct inspect with data 1 i/100ms
# AStruct inspect with data 1 i/100ms
# -------------------------------------------------
# OStruct inspect with data 8.2 (±24.4%) i/s - 40 in 5.085258s
# AStruct inspect with data 9.1 (±21.9%) i/s - 45 in 5.063373s

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
