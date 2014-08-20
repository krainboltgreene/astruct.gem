require "set"

class AltStruct
  # An AltStruct is a data structure, similar to a Hash, that allows the
  # definition of arbitrary attributes with their accompanying values. This is
  # accomplished by using Ruby's meta-programming to define methods on the
  # class itself.
  #
  #
  # == Examples:
  #
  #     require 'astruct'
  #
  #     class Profile < AltStruct
  #
  #     end
  #
  #     person = Profile.new name: "John Smith"
  #     person.age = 70
  #
  #     puts person.name     # => "John Smith"
  #     puts person.age      # => 70
  #     puts person.dump     # => { :name => "John Smith", :age => 70 }
  #
  # An AltStruct employs a Hash internally to store the methods and values and
  # can even be initialized with one:
  #
  #     australia = AltStruct.new(
  #       country: "Australia",
  #       population: 20_000_000
  #     )
  #     puts australia.inspect
  #       # => <AltStruct country="Australia", population=20000000>
  #
  # Hash keys with spaces or characters that would normally not be able to use
  # for method calls (e.g. ()[]*) will not be immediately available on the
  # AltStruct object as a method for retrieval or assignment, but can be still
  # be reached through the `Object#send` method.
  #
  #     measurements = AltStruct.new "length (in inches)" => 24
  #     measurements.send "length (in inches)"  # => 24
  #
  #     data_point = AltStruct.new :queued? => true
  #     data_point.queued?                       # => true
  #     data_point.send "queued?=", false
  #     data_point.queued?                       # => false
  #
  # Removing the presence of a method requires the execution the delete_field
  # or delete (like a hash) method as setting the property value to +nil+
  # will not remove the method.
  #
  #     first_pet = AltStruct.new :name => 'Rowdy', :owner => 'John Smith'
  #     first_pet.owner = nil
  #     second_pet = AltStruct.new :name => 'Rowdy'
  #
  #     first_pet == second_pet   # -> false
  #
  #     first_pet.delete_field(:owner)
  #     first_pet == second_pet   # -> true
  #
  #
  # == Implementation:
  #
  # An AltStruct utilizes Ruby's method lookup structure to and find and define
  # the necessary methods for properties. This is accomplished through the
  # method `method_missing` and `define_singleton_method`.
  #
  # This should be a consideration if there is a concern about the performance
  # of the objects that are created, as there is much more overhead in the
  # setting of these properties compared to using a Hash or a Struct.
  module Behavior
    THREAD_KEY = :__astruct_inspect_ids__ # :nodoc:
    NESTED_INSPECT = "...".freeze
    INSPECT_DELIMITER = ", ".freeze

    # We want to give easy access to the table
    attr_reader :table

    # We want to automatically wrap important Ruby object methods
    Object.instance_methods.each do |m|
      case m

      # Don't bother with already wrapped methods
      when /__/ then next

      # Skip methods that can't be set anyways
      when /\@|\[|\]|\=\=|\~|\>|\<|\!\=/ then next

      # Get around Ruby's stupid method signature problems with ? and !
      # suffixes
      when /(\?|\!)$/ then alias_method "__#{m[0...-1]}__#{m[-1]}".to_sym, m

      # Finally, wrap regular methods
      else alias_method "__#{m}__".to_sym, m
      end
    end

    # Create a new field for each of the key/value pairs passed.
    # By default the resulting OpenStruct object will have no
    # attributes. If no pairs are passed avoid any work.
    #
    #    require "astruct"
    #    hash = { "country" => "Australia", :population => 20_000_000 }
    #    data = AltStruct.new hash
    #
    #    p data # => <AltStruct country="Australia" population=20000000>
    #
    # If you happen to be inheriting then you can define your own
    # `@table` ivar before the `super()` call. AltStruct will respect
    # your `@table`.
    #
    def initialize(pairs = {})
      @table ||= {}
      __iterate_set_over__(pairs) unless pairs.empty?
    end

    # This is the `load()` method, which works like initialize in that it
    # will create new fields for each pair passed. It mimics the behavior of a
    # Hash#merge.
    def __load__(pairs)
      __iterate_set_over__(pairs) unless pairs.empty?
    end
    alias_method :marshal_load, :__load__
    alias_method :load, :__load__
    alias_method :merge, :__load__

    # This is the `load!()` method, which works like Hash#merge!
    # See: `AltStruct#load()`
    def __load__!(pairs)
      __iterate_set_over__(pairs, true)
    end
    alias_method :marshal_load!, :__load__!
    alias_method :load!, :__load__!
    alias_method :merge!, :__load__!

    # The `dump()` takes the table and out puts in it's natural hash
    # format. In addition you can pass along a specific set of keys to
    # dump.
    def __dump__(*keys)
      if keys.empty? then @table else __dump_specific__(keys) end
    end
    alias_method :marshal_dump, :__dump__
    alias_method :dump, :__dump__
    alias_method :to_hash, :__dump__

    def __inspect__
      "#<#{__class__}#{__dump_inspect__}>"
    end
    alias_method :inspect, :__inspect__
    alias_method :to_sym, :__inspect__

    # The `delete()` method removes a key/value pair on the @table
    # and on the singleton class. It also mimics the Hash#delete method.
    def __delete__(key)
      __singleton_class__.send(:remove_method, key)
      __singleton_class__.send(:remove_method, "#{key}=")
      @table.delete(key.to_sym)
    end
    alias_method :delete_field, :__delete__
    alias_method :delete, :__delete__

    # The `method_missing()` method catches all non-tabled method calls.
    # The AltStruct object will return two specific errors depending on
    # the call.
    def method_missing(method, *args)
      name = method.to_s
      if name.split("").last == "=" && args.size == 1
        __define_field__(name.chomp!("="), args.first)
      else
        if name.split.last != "="
          super
        else args.size > 1
          raise ArgumentError,"wrong number of arguments (#{args.size} for 1)"
        end
      end
    end

    def ==(other)
      if other.respond_to?(:table)
        table == other.table
      else
        false
      end
    end

    def freeze
      super
      @table.freeze
    end
    alias_method :__freeze__, :freeze
    alias_method :__frozen?, :frozen?

    private

    def __dump_inspect__
      Thread.current[THREAD_KEY] ||= Set.new

      if __dump__.any? then " #{__dump_subinspect__}" else "" end.tap do
        __thread_ids__.delete(__object_id__)
      end
    end

    def __dump_subinspect__
      if __thread_ids__.add?(__object_id__)
        __dump_string__.join(INSPECT_DELIMITER)
      else
        NESTED_INSPECT
      end
    end

    def __thread_ids__
      Thread.current[THREAD_KEY]
    end

    def __define_field__(key, value)
      __define_accessor__(key)
      __set_table__(key, value)
    end

    def __define_accessor__(key)
      singleton_class.send(:define_method, key) { @table[key] }
      singleton_class.send(:define_method, "#{key}=") { |v| @table[key] = v }
    end

    def __set_table__(key, value)
      @table.merge!(key => value) unless key.nil?
    end

    def __dump_specific__(keys)
      @table.keep_if { |key| keys.include?(key.to_sym) }
    end

    def __dump_string__
      __dump__.map { |key, value| "#{key}=#{value.inspect}" }
    end

    def __iterate_set_over__(pairs, force = false)
      for key, value in pairs
        if force && respond_to?(key)
          __set_table__(key, value)
        else
          __define_accessor__(key)
          __set_table__(key, value)
        end
      end
    end
  end
end
