require_relative 'astruct/module'

#
# = astruct.rb: AltStruct implementation
#
# Author:: Kurtis Rainbolt-Greene
# Documentation:: Kurtis Rainbolt-Greene
#
# AltStruct is an Class and Module (AltStruct::M) that can be used to
# create hash-like classes. Allowing you to create an object that can
# dynamically accept accessors and behaves very much like a Hash.
#

#
# An AltStruct is a data structure, similar to a Hash, that allows the
# definition of arbitrary attributes with their accompanying values. This is
# accomplished by using Ruby's metaprogramming to define methods on the class
# itself.
#

#
# == Examples:
#
#   require 'astruct'
#
#   class Profile < AltStruct
#
#   end
#
#   person = Profile.new name: "John Smith"
#   person.age = 70
#
#   puts person.name     # => "John Smith"
#   puts person.age      # => 70
#   puts person.dump     # => { :name => "John Smith", :age => 70 }
#

#
# An AltStruct employs a Hash internally to store the methods and values and
# can even be initialized with one:
#
#   australia = AltStruct.new country: "Australia", population: 20_000_000
#   puts australia.inspect # => <AltStruct country="Australia", population=20000000>
#

#
# Hash keys with spaces or characters that would normally not be able to use for
# method calls (e.g. ()[]*) will not be immediately available on the
# AltStruct object as a method for retrieval or assignment, but can be still be
# reached through the Object#send method.
#
#   measurements = AltStruct.new "length (in inches)" => 24
#   measurements.send "length (in inches)"  # => 24
#
#   data_point = AltStruct.new :queued? => true
#   data_point.queued?                       # => true
#   data_point.send "queued?=", false
#   data_point.queued?                       # => false
#

#
# Removing the presence of a method requires the execution the delete_field
# or delete (like a hash) method as setting the property value to +nil+
# will not remove the method.
#
#   first_pet = AltStruct.new :name => 'Rowdy', :owner => 'John Smith'
#   first_pet.owner = nil
#   second_pet = AltStruct.new :name => 'Rowdy'
#
#   first_pet == second_pet   # -> false
#
#   first_pet.delete_field(:owner)
#   first_pet == second_pet   # -> true
#

#
# == Implementation:
#
# An AltStruct utilizes Ruby's method lookup structure to and find and define
# the necessary methods for properties. This is accomplished through the method
# method_missing and define_method.
#

#
# This should be a consideration if there is a concern about the performance of
# the objects that are created, as there is much more overhead in the setting
# of these properties compared to using a Hash or a Struct.
#
class AltStruct
  # We include all of the AltStruct::M Module in order to give AltStruct
  # the same behavior as OpenStruct. It's better, however, to simply
  # include AltStruct::M into your own class.
  include AltStruct::M
end
