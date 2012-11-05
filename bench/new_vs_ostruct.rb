require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct new with data" do
    class OProfile < OpenStruct; end
    OProfile.new DATA.dup
  end

  x.report "AStruct new with data" do
    class AProfile < AltStruct; end
    AProfile.new DATA.dup
  end
end
# Calculating -------------------------------------
# OStruct new with data 1 i/100ms
# AStruct new with data 1 i/100ms
# -------------------------------------------------
# OStruct new with data 8.6 (±23.2%) i/s - 42 in 5.041086s
# AStruct new with data 9.7 (±30.8%) i/s - 47 in 5.101214s

# 2012-11-04 16:06:37 -0800
# Calculating -------------------------------------
# OStruct new with data
#                              1 i/100ms
# AStruct new with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data
#                             5.4 (±18.5%) i/s -         26 in   5.018563s
# AStruct new with data
#                             6.8 (±29.3%) i/s -         32 in   5.056314s
