require 'benchmark/ips'
require_relative '../lib/astruct'
require 'ostruct'

DATA = (1..1_000).map { |i| { :"item#{i}" => i } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct creation" do
    class OProfile < OpenStruct; end
    OProfile.new DATA.dup
  end

  x.report "AStruct creation" do
    class AProfile < AltStruct; end
    AProfile.new DATA.dup
  end
end
