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
