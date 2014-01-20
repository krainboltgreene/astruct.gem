require "astruct"
require "ruby-prof"

result = RubyProf.profile do

end

# Print a graph profile to text
printer = RubyProf::MultiPrinter.new(result)
printer.print(path: File.join("..", "tmp"), profile: "new")
