require "ruby-prof"
require "ostruct"
require "astruct"
require "securerandom"

DATA = (1..50).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)
DATA2 = (51..101).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)

class AProfile < AltStruct; end

result = RubyProf.profile do
  ap = AProfile.new(DATA.dup)
  ap.load(DATA2.dup)
end

printer = RubyProf::MultiPrinter.new(result)
printer.print(path: File.join("tmp"), profile: "add_more")
