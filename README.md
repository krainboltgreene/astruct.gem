astruct
-------


  - [![Quality](http://img.shields.io/codeclimate/github/krainboltgreene/astruct.gem.svg?style=flat-square)](https://codeclimate.com/github/krainboltgreene/astruct.gem)
  - [![Coverage](http://img.shields.io/codeclimate/coverage/github/krainboltgreene/astruct.gem.svg?style=flat-square)](https://codeclimate.com/github/krainboltgreene/astruct.gem)
  - [![Build](http://img.shields.io/travis-ci/krainboltgreene/astruct.gem.svg?style=flat-square)](https://travis-ci.org/krainboltgreene/astruct.gem)
  - [![Dependencies](http://img.shields.io/gemnasium/krainboltgreene/astruct.gem.svg?style=flat-square)](https://gemnasium.com/krainboltgreene/astruct.gem)
  - [![Downloads](http://img.shields.io/gem/dtv/astruct.svg?style=flat-square)](https://rubygems.org/gems/astruct)
  - [![Tags](http://img.shields.io/github/tag/krainboltgreene/astruct.gem.svg?style=flat-square)](http://github.com/krainboltgreene/astruct.gem/tags)
  - [![Releases](http://img.shields.io/github/release/krainboltgreene/astruct.gem.svg?style=flat-square)](http://github.com/krainboltgreene/astruct.gem/releases)
  - [![Issues](http://img.shields.io/github/issues/krainboltgreene/astruct.gem.svg?style=flat-square)](http://github.com/krainboltgreene/astruct.gem/issues)
  - [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](http://opensource.org/licenses/MIT)
  - [![Version](http://img.shields.io/gem/v/astruct.svg?style=flat-square)](https://rubygems.org/gems/astruct)

`AltStruct` is a direct alternative to OpenStruct, the Ruby class from the Standard Library.


Using
=====

You can use `AltStruct` exactly like `OpenStruct`:

``` ruby
require "astruct"

person = AltStruct.new(name: "Kurtis Rainbolt-Greene", age: 23, friends: [])
person.name
  # => "Kurtis Rainbolt-Greene"
person.age
  # => 23
person.location = "Los Angeles, CA"
person.location
  # => "Los Angeles, CA"

class Person < AltStruct
  # ...Custom logic...
end

person2 = Person.new(name: "Angela Englund")
person2.name
  # => "Angela Englund"
```

Here is where `AltStruct` differs:

``` ruby
# We have access to a merge method, like Hash. It doesn't overwrite the entire
# tree anymore, like OpenStruct#marshal_load.
person.merge({ name: "James Caldwell" })
person.name
  # => "James Caldwell"
person.age
  # => 23

# You no longer completely overwrite core Ruby object methods:
person.object_id
  # => ...
person.inspect
  # => ...
person.object_id = 1
person.object_id
  # => 1
person.inspect
  # => ...
person.__object_id__
```

``` ruby
# You can now mixin behavior instead of forcing inheritence:
class Person
  include AltStruct::Behavior
end
```

We've also fixed some problematic bugs.


Installing
==========

Add this line to your application's Gemfile:

    gem "astruct", "~> 3.0"

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install astruct


Contributing
============

  1. Read the [Code of Conduct](/CONDUCT.md)
  2. Fork it
  3. Create your feature branch (`git checkout -b my-new-feature`)
  4. Commit your changes (`git commit -am 'Add some feature'`)
  5. Push to the branch (`git push origin my-new-feature`)
  6. Create new Pull Request


License
=======

Copyright (c) 2014, 2015 Kurtis Rainbolt-Greene

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
