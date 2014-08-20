require "benchmark/ips"
require "ostruct"
require "astruct"

DATA = (1..5_000).map { |i| { "key#{i}" => "value#{i}" } }.inject :merge!
UPDATE = DATA.merge (1..2_500).map { |i| { "key#{i}" => "value#{i + rand(1..3)}" } }.inject :merge!

Benchmark.ips do |x|
  x.report "OStruct" do
    class OProfile < OpenStruct; end
    op = OProfile.new DATA.dup
    op.marshal_load op.marshal_dump.merge UPDATE.dup
  end

  x.report "AStruct" do
    class AProfile < AltStruct; end
    ap = AProfile.new DATA.dup
    ap.load UPDATE.dup
  end
end
