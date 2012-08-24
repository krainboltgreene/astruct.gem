# -*- encoding: utf-8 -*-
require File.expand_path('../lib/astruct/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kurtis Rainbolt-Greene"]
  gem.email         = ["kurtisrainboltgreene@gmail.com"]
  gem.summary       = %q{An alternative to OpenStruct}
  gem.description   = gem.summary
  gem.homepage      = "http://krainboltgreene.github.com/astruct"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "astruct"
  gem.require_paths = ["lib"]
  gem.version       = AltStruct::VERSION

  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'kramdown'
end
