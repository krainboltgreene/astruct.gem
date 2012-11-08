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
# 
# PLATFORM: ruby 1.9.3p286 (2012-10-12 revision 37165) [x86_64-darwin12.2.0]
# TIMESTAMP: 2012-11-06 11:19:28 -0800
# ---
# Calculating -------------------------------------
# OStruct new with data
#                              1 i/100ms
# AStruct new with data
#                              1 i/100ms
# -------------------------------------------------
# OStruct new with data
#                             4.3 (±23.4%) i/s -         21 in   5.130880s
# AStruct new with data
#                             5.2 (±38.7%) i/s -         25 in   5.211888s
