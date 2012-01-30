module AltStruct
  attr_reader :table

  def initialize(pairs = {})
    @table ||= {}
    for key, value in pairs
      @table.merge! define_accessor key.to_sym, value
    end unless pairs == {}
  end

  def define_accessor(key, value)
    define_singleton_method(key) { @table[key] }
    define_singleton_method(:"#{key}=") { |v| @table[key] = v }
    { key => value }.freeze
  end

  def load(pairs)
    for key, value in pairs
      @table.merge! define_accessor key.to_sym, value
    end unless pairs == {}
  end

  def dump(*keys)
    if keys == [] then @table else @table.keep_if { |k| keys.include? k } end
  end

  def inspect
    "#<#{self.class}:#{object_id} #{dump.map { |k,v| "#{k}=#{v.inspect}" }.join ' '}>"
  end
end
