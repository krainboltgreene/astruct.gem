class AltStruct
  module M
    ThreadKey = :__inspect_astruct_ids__ # :nodoc:
    attr_reader :table

    # Create a new field for each of the key/value pairs passed.
    # By default the resulting OpenStruct object will have no
    # attributes. If no pairs are passed avoid any work.
    #
    #    require 'ostruct'
    #    hash = { "country" => "Australia", :population => 20_000_000 }
    #    data = OpenStruct.new hash
    #
    #    p data # => <OpenStruct country="Australia" population=20000000>
    #
    # If you happen to be inheriting then you can define your own
    # @table ivar before the `super()` call. AltStruct will respect
    # your @table.
    #
    def initialize(pairs = {})
      @table ||= {}
      for key, value in pairs
        __new_field__ key, value
      end unless pairs.empty?
    end

    # This is the `load()` method, which works like initialize in that it
    # will create new fields for each pair passed. Notice that it
    # also is a double-underbar method, making it really hard to
    # overwrite. It also mimics the behavior of a Hash#merge and
    # Hash#merge!
    def __load__(pairs)
      for key, value in pairs
        __new_field__ key, value
      end unless pairs.empty?
    end
    alias_method :marshal_load, :__load__
    alias_method :load, :__load__
    alias_method :merge, :__load__
    alias_method :merge!, :__load__

    # The `dump()` takes the table and out puts in it's natural hash
    # format. In addition you can pass along a specific set of keys to
    # dump.
    def __dump__(*keys)
      keys.empty? ? table : __dump_specific__(keys)
    end
    alias_method :marshal_dump, :__dump__
    alias_method :dump, :__dump__
    alias_method :to_hash, :__dump__

    def __inspect__
      "#<#{self.class}#{__dump_inspect__}>"
    end
    alias_method :inspect, :__inspect__
    alias_method :to_s, :__inspect__

    # The delete_field() method removes a key/value pair on the @table
    # and on the singleton class. It also mimics the Hash#delete method.
    def __delete_field__(key)
      singleton_class.send :remove_method, key
      singleton_class.send :remove_method, :"#{key}="
      @table.delete key
    end
    alias_method :delete_field, :__delete_field__
    alias_method :delete, :__delete_field__

    # The `method_missing()` method catches all non-tabled method calls.
    # The AltStruct object will return two specific errors depending on
    # the call.
    def method_missing(method, *args)
      name = method.to_s
      case
      when !name.include?('=')
        # This is to catch non-assignment methods
        message = "undefined method `#{name}' for #{self}"
        raise NoMethodError, message, caller(1)
      when args.size != 1
        # This is to catch the []= method
        message = "wrong number of arguments (#{args.size} for 1)"
        raise ArgumentError, message, caller(1)
      else
        __new_field__ name.chomp!('='), args.first
      end
    end

    def ==(object)
      if object.respond_to? :table
        table == object.table
      else
        false
      end
    end

    def freeze
      super
      @table.freeze
    end

    private

    def __dump_inspect__
      __create_id_list__
      unless __id_exists_in_id_list?
        __add_id_to_id_list__
        string = __dump__.any? ? " #{__dump_string__.join ', '}" : ""
      else
        __remove_id_from_id_list__
        string = __dump__.any? ? " ..." : ""
      end
      string
    end

    def __define_accessor__(key, value)
      define_singleton_method(key) { @table[key] }
      define_singleton_method(:"#{key}=") { |v| @table[key] = v }
      { key => value }.freeze
    end

    def __new_field__(key, value)
      table.merge! __define_accessor__ key.to_sym, value
    end

    def __dump_specific__(keys)
      @table.keep_if { |key| keys.include? key }
    end

    def __dump_string__
      __dump__.map do |key, value|
        "#{key}=#{value.inspect}"
      end
    end

    def __add_id_to_id_list__
      Thread.current[ThreadKey] << object_id
    end

    def __create_id_list__
      Thread.current[ThreadKey] ||= []
    end

    def __id_exists_in_id_list?
      Thread.current[ThreadKey].include?(object_id)
    end

    def __remove_id_from_id_list__
      Thread.current[ThreadKey].pop
    end
  end
end
