require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

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
