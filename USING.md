USING
-----

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
