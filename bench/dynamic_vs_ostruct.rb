require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..10_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!

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
