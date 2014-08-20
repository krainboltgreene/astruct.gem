require "ruby-prof"
require "astruct"

result = RubyProf.profile do
  AltStruct.new
end

printer = RubyProf::MultiPrinter.new(result)
printer.print(path: File.join("tmp"), profile: "new_without_data")
