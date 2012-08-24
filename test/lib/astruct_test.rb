require 'minitest/autorun'
require '../helper'

class Profile
  include AltStruct::M
end

class TestAltStruct < MiniTest::Unit::TestCase
  def setup
    @empty = AltStruct.new
    @example = AltStruct.new name: "Kurtis", age: 24
  end

  def test_equality
    struct2 = AltStruct.new
    assert_equal(@empty, struct2)

    @empty.a = 'a'
    refute_equal(@empty, struct2)

    struct2.a = 'a'
    assert_equal(@empty, struct2)

    @empty.a = 'b`'
    refute_equal(@empty, struct2)

    struct3 = Object.new
    struct3.instance_eval { @table = {:a => 'b'} }
    refute_equal(@empty, struct3)
  end

  def test_inspect_with_no_fields
    assert_equal("#<AltStruct>", @empty.inspect)
  end

  def test_inspect_with_fields
    @empty.example1 = 1
    @empty.example2 = 2
    assert_equal("#<AltStruct example1=1, example2=2>", @empty.inspect)
  end

  def test_inspect_with_sub_struct
    @empty.struct2 = AltStruct.new
    @empty.struct2.struct3 = @empty
    assert_equal('#<AltStruct struct2=#<AltStruct struct3=#<AltStruct ...>>>', @empty.inspect)
  end

  def test_inspect_with_empty_sub_struct
    @empty.struct2 = AltStruct.new
    assert_equal('#<AltStruct struct2=#<AltStruct>>', @empty.inspect)
  end

  def test_freeze_stops_new_assignments
    @example.freeze
    assert_raises(RuntimeError) { @example.age = 24 }
    # assert_raises(TypeError) { @example.age = 24 }
  end

  def test_freeze_still_returns_values
    @example.freeze
    expects = "Kurtis"
    actual =  @example.name
    assert_equal expects, actual
  end

  def test_freeze_stops_reassignments
    @example.freeze
    assert_raises(RuntimeError) { @example.name = "Jazzy" }
    # assert_raises(TypeError) { @example.name = "Jazzy" }
  end

  # def test_freeze_stops_reassign_even_if_frozen_redefined
  #   @example.freeze
  #   def @example.frozen?; nil end
  #   @example.freeze
  #   message = '[ruby-core:22559]'
  #   assert_raises(RuntimeError, message) { @example.name = "Jazzy" }
  #   # assert_raises(TypeError, message) { @example.name = "Jazzy" }
  # end

  def test_delete_field
    bug = '[ruby-core:33010]'

    refute_respond_to(@empty, :akey)
    refute_respond_to(@empty, :akey=)

    @empty.akey = 'avalue'
    assert_respond_to(@empty, :akey)
    assert_respond_to(@empty, :akey=)

    avalue = @empty.delete_field :akey
    refute_respond_to(@empty, :akey, bug)
    refute_respond_to(@empty, :akey=, bug)

    assert_equal(avalue, 'avalue')
  end

  def test_method_missing_handles_square_bracket_equals
    assert_raises(ArgumentError) { @empty[:foo] = :bar }
    # assert_raises(NoMethodError) { @empty[:foo] = :bar }
  end

  def test_method_missing_handles_square_brackets
    assert_raises(NoMethodError) { @empty[:foo] }
  end

  def test_to_hash_returns_hash
    expect = { name: "John Smith", age: 70, pension: 300 }
    actual = AltStruct.new(expect).to_hash
    assert_equal expect, actual
  end

  def test_to_hash_modified_modifies_astruct
    @example.to_hash[:age] = 70
    expect = 70
    actual = @example.age
    assert_equal expect, actual
  end

  def test_that_example_has_table_method
    assert_respond_to @example, :table
  end

  def test_that_empty_example_has_empty_table
    expect = {}
    actual = @empty.table
    assert_equal expect, actual
  end

  def test_that_example_has_name_method
    assert_respond_to @example, :name
  end

  def test_that_example_has_given_name
    expect = "Kurtis"
    actual = @example.name
    assert_equal expect, actual
  end

  def test_that_example_takes_name
    assert_send [@example, :name=, "Dave"]
  end

  def test_that_example_has_taken_name
    @example.name = "Dave"
    expect = "Dave"
    actual = @example.name
    assert_equal expect, actual
  end

  def test_that_load_takes_a_hash
    assert_send  [@example, :load, { nickname: "Kurt" }]
  end

  def test_that_load_sets_methods
    @example.load nickname: "Kurt"
    assert_respond_to @example, :nickname
  end

  def test_that_load_sets_correct_value
    @example.load nickname: "Kurt"
    expect = "Kurt"
    actual = @example.nickname
    assert_equal expect, actual
  end

  def test_that_example_has_dump_method
    assert_respond_to @example, :dump
  end

  def test_that_dump_contains_values
    expect = { name: "Kurtis", age: 24 }
    actual = @example.dump
    assert_equal expect, actual
  end

  def test_that_selective_dump_contains_selective_values
    expect = { age: 24 }
    actual = @example.dump :age
    assert_equal expect, actual
  end

  def test_inspect_has_values
    expect = /name="Kurtis", age=24/
    actual = @example.inspect
    assert_match expect, actual
  end

  def test_that_other_class_isnt_affected
    refute_respond_to @empty, :name
  end
end

