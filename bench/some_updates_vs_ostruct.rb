require 'benchmark/ips'
require 'astruct'
require 'ostruct'

DATA = (1..1_0).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!
UPDATE = DATA.merge (1..5).map { |i| { "key#{i}" => "value#{i + rand(1..3)}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct load with data" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.marshal_load op.marshal_dump.merge UPDATE.dup
  end

  x.report "AStruct load with data" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.load UPDATE.dup
  end
end
