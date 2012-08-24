class AltStruct
  module M
    ThreadKey = :__inspect_astruct_ids__ # :nodoc:
    attr_reader :table

    def initialize(pairs = {})
      @table ||= {}
      for key, value in pairs
        __new_field__ key, value
      end unless pairs.empty?
    end

    def __load__(pairs)
      for key, value in pairs
        __new_field__ key, value
      end unless pairs.empty?
    end
    alias_method :marshal_load, :__load__
    alias_method :load, :__load__
    alias_method :merge, :__load__
    alias_method :merge!, :__load__

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

    def __delete_field__(key)
      self.singleton_class.send :remove_method, key
      self.singleton_class.send :remove_method, :"#{key}="
      @table.delete key
    end
    alias_method :delete_field, :__delete_field__
    alias_method :delete, :__delete_field__

    def method_missing(method, *args)
      name = method.to_s
      case
      when !name.include?('=')
        message = "undefined method `#{name}' for #{self}"
        raise NoMethodError, message, caller(1)
      when args.size != 1
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
        __dump__.any? ? " #{__dump_string__.join ', '}" : ""
      else
        __remove_id_from_id_list__
        __dump__.any? ? " ..." : ""
      end
    end

    def __define_accessor__(key, value)
      define_singleton_method(key) { @table[key] }
      define_singleton_method(:"#{key}=") { |value| @table[key] = value }
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
