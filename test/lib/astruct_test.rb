require 'minitest/autorun'
require_relative '../helper'

class TestAltStruct < MiniTest::Unit::TestCase
  def setup
    @empty = AltStruct.new
    @example = AltStruct.new name: "Kurtis", age: 24
  end

  def test_equality_with_two_empty_astructs
    empty2 = AltStruct.new
    assert_equal @empty, empty2
  end

  def test_equality_vs_astruct_with_fields
    refute_equal @example, @empty
  end

  def test_equality_vs_object_with_fake_table
    empty_object = Object.new
    empty_object.instance_eval { @table = { name: "Kurtis", age: 24 }  }
    expected = @example
    actual = empty_object
    refute_equal expected, actual
  end

  def test_inspect_with_no_fields
    expected = "#<AltStruct>"
    actual = @empty.inspect
    assert_equal expected, actual
  end

  def test_inspect_with_fields
    @empty.example1 = 1
    @empty.example2 = 2
    expected = "#<AltStruct example1=1, example2=2>"
    actual = @empty.inspect
    assert_equal expected, actual
  end

  def test_inspect_with_sub_struct_duplicate
    @empty.struct2 = AltStruct.new
    @empty.struct2.struct3 = @empty
    expected = '#<AltStruct struct2=#<AltStruct struct3=#<AltStruct ...>>>'
    actual = @empty.inspect
    assert_equal expected, actual
  end

  def test_inspect_with_sub_struct
    @example.friends = AltStruct.new name: "Jason", age: 24
    @example.friends.friends.friends = AltStruct.new name: "Ally", age: 32
    expected = '#<AltStruct name="Kurtis", age=24, friends=#<AltStruct name="Jason", age=24, friends=#<AltStruct name="John", age=15, friends=#<AltStruct name="Ally", age=32>>>>'
    actual = @example.inspect
    assert_equal expected, actual
  end
  def test_inspect_with_empty_sub_struct
    @empty.struct2 = AltStruct.new
    expected = '#<AltStruct struct2=#<AltStruct>>'
    actual = @empty.inspect
    assert_equal expected, actual
  end

  def test_freeze_stops_new_assignments
    @example.freeze
    assert_raises(RuntimeError) { @example.age = 24 }
  end

  def test_freeze_still_returns_values
    @example.freeze
    expecteds = "Kurtis"
    actual =  @example.name
    assert_equal expecteds, actual
  end

  def test_freeze_stops_reassignments
    @example.freeze
    assert_raises(RuntimeError) { @example.name = "Jazzy" }
  end

  # def test_freeze_stops_reassign_even_if_frozen_redefined
  #   @example.freeze
  #   def @example.frozen?; nil end
  #   @example.freeze
  #   message = '[ruby-core:22559]'
  #   assert_raises(RuntimeError, message) { @example.name = "Jazzy" }
  #   # assert_raises(TypeError, message) { @example.name = "Jazzy" }
  # end

  def test_astruct_doesn_respond_to_non_existant_keys_getter
    refute_respond_to @empty, :akey
  end

  def test_astruct_doesn_respond_to_non_existant_keys_setter
    refute_respond_to @empty, :akey=
  end

  def test_delete_field_removes_getter_method
    bug = '[ruby-core:33010]'
    @example.delete_field :name
    refute_respond_to @example, :name, bug
  end

  def test_delete_field_removes_setter_method
    bug = '[ruby-core:33010]'
    @example.delete_field :name
    refute_respond_to @example, :name=, bug
  end

  def test_delete_field_removes_table_key_value
    @example.delete_field :name
    expected = nil
    actual = @example.table[:name]
    assert_equal expected, actual
  end

  def test_delete_field_returns_value_of_deleted_key
    expected = "Kurtis"
    actual = @example.delete_field :name
    assert_equal expected, actual
  end

  def test_method_missing_handles_square_bracket_equals
    assert_raises(ArgumentError) { @empty[:foo] = :bar }
  end

  def test_method_missing_handles_square_brackets
    assert_raises(NoMethodError) { @empty[:foo] }
  end

  def test_to_hash_returns_hash
    expected = { name: "John Smith", age: 70, pension: 300 }
    actual = AltStruct.new(expected).to_hash
    assert_equal expected, actual
  end

  def test_to_hash_modified_modifies_astruct
    @example.to_hash[:age] = 70
    expected = 70
    actual = @example.age
    assert_equal expected, actual
  end

  def test_example_has_table_method
    assert_respond_to @example, :table
  end

  def test_empty_example_has_empty_table
    expected = {}
    actual = @empty.table
    assert_equal expected, actual
  end

  def test_example_has_name_method
    assert_respond_to @example, :name
  end

  def test_example_has_given_name
    expected = "Kurtis"
    actual = @example.name
    assert_equal expected, actual
  end

  def test_example_takes_name
    assert_send [@example, :name=, "Dave"]
  end

  def test_example_has_taken_name
    @example.name = "Dave"
    expected = "Dave"
    actual = @example.name
    assert_equal expected, actual
  end

  def test_load_takes_a_hash
    assert_send  [@example, :load, { nickname: "Kurt" }]
  end

  def test_load_sets_methods
    @example.load nickname: "Kurt"
    assert_respond_to @example, :nickname
  end

  def test_astruct_has_getter_methods_with_non_alpha_numeric_characters
    @example.load "Length (In Inchs)" => 72
    assert_send  [@example, :"Length (In Inchs)"]
  end

  def test_astruct_has_getter_methods_with_non_alpha_numeric_characters
    @example.load "Length (In Inchs)" => 72
    assert_send  [@example, :"Length (In Inchs)=", 73]
  end

  def test_load_sets_correct_value
    @example.load nickname: "Kurt"
    expected = "Kurt"
    actual = @example.nickname
    assert_equal expected, actual
  end

  def test_example_has_dump_method
    assert_respond_to @example, :dump
  end

  def test_dump_contains_values
    expected = { name: "Kurtis", age: 24 }
    actual = @example.dump
    assert_equal expected, actual
  end

  def test_selective_dump_contains_selective_values
    expected = { age: 24 }
    actual = @example.dump :age
    assert_equal expected, actual
  end

  def test_inspect_has_values_delimited_by_comma
    expected = /name="Kurtis", age=24/
    actual = @example.inspect
    assert_match expected, actual
  end

  def test_other_object_isnt_affected
    refute_respond_to @empty, :name
  end
end

