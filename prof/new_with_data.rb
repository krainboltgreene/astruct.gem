require "ruby-prof"
require "astruct"
require "securerandom"

DATA = (1..5_000).map { |i| { SecureRandom.hex => SecureRandom.hex } }.inject(:merge!)

class AProfile < AltStruct; end

result = RubyProf.profile do
  AProfile.new DATA.dup
end

printer = RubyProf::MultiPrinter.new(result)
printer.print(path: File.join("tmp"), profile: "new_with_data")
