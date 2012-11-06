require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

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
# 
# PLATFORM: rubinius 2.0.0rc1 (1.9.3 release 2012-11-02 JI) [x86_64-apple-darwin12.2.0]
# TIMESTAMP: 2012-11-05 10:17:04 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data
#                              1 i/100ms
# AStruct new with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data
#                             2.9 (±35.1%) i/s -         14 in   5.118216s
# AStruct new with data
#                             2.8 (±0.0%) i/s -         14 in   5.045878s
