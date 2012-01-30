require 'benchmark'
require 'astruct'
require 'ostruct'

ODATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!
ADATA = (1..10_000).map { |i| { :"item#{i}" => i } }.inject :merge!

report = Benchmark.bmbm do |x|
  x.report "OStruct creation" do
    class OProfile < OpenStruct; end
    OProfile.new ODATA
  end

  x.report "AStruct creation" do
    class AProfile; include AltStruct; end
    AProfile.new ADATA
  end
end

puts "Astruct is #{report.map(&:to_s).map(&:split).map(&:last).map(&:to_f).inject(:/) * 100 - 100}% faster"

report = Benchmark.bmbm do |x|
  x.report "OStruct load" do
    class OProfile < OpenStruct; end
    op = OProfile.new
    op.load ODATA
  end

  x.report "AStruct load" do
    class AProfile; include AltStruct; end
    ap = AProfile.new
    ap.load ADATA
  end
end

puts "Astruct is #{report.map(&:to_s).map(&:split).map(&:last).map(&:to_f).inject(:/) * 100 - 100}% faster"