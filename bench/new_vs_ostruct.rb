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
