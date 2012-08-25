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

class OProfile < OpenStruct; end
op = OProfile.new DATA.dup
class AProfile < AltStruct; end
ap = AProfile.new DATA.dup
puts "The output of each is the same: #{ap.dump == op.marshal_dump}"
# Calculating -------------------------------------
# OStruct dump with data 1 i/100ms
# AStruct dump with data 1 i/100ms
# -------------------------------------------------
# OStruct dump with data 9.0 (±22.2%) i/s - 44 in 5.055799s
# AStruct dump with data 10.2 (±29.4%) i/s - 48 in 5.073042s
