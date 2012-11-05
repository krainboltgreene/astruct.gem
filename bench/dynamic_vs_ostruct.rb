require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

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
# Calculating -------------------------------------
# OStruct new with data then assign new data 1 i/100ms
# AStructt new with data then assign new data 1 i/100ms
# -------------------------------------------------
# OStruct new with data then assign new data 8.5 (±11.8%) i/s - 42 in 5.078029s
# AStructt new with data then assign new data 9.4 (±32.0%) i/s - 43 in 5.005849s

# 2012-11-04 16:05:35 -0800
# Calculating -------------------------------------
# OStruct new with data then assign new data
#                              1 i/100ms
# AStructt new with data then assign new data
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data then assign new data
#                             5.2 (±19.4%) i/s -         26 in   5.189538s
# AStructt new with data then assign new data
#                             6.7 (±29.6%) i/s -         31 in   5.021870s
