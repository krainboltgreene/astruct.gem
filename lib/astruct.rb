require_relative "astruct/behavior"

# = astruct.rb: AltStruct implementation
#
# Author:: Kurtis Rainbolt-Greene
# Documentation:: Kurtis Rainbolt-Greene
#
# AltStruct is an Class and Module (AltStruct::M) that can be used to
# create hash-like classes. Allowing you to create an object that can
# dynamically accept accessors and behaves very much like a Hash.
#
class AltStruct
  # We include all of the AltStruct::Behavior Module in order to give AltStruct
  # the same behavior as OpenStruct. It's better, however, to simply
  # include AltStruct::Behavior into your own class.
  include AltStruct::Behavior
end

require_relative "astruct/version"
