require 'minitest/autorun'
require_relative 'test_helper'

class TestAltStruct < MiniTest::Unit::TestCase
  def setup
    @empty_example = Profile.new
    @example = Profile.new name: "Kurtis", age: 24
  end

  def test_that_example_is_kind_of_altstruct
    assert_kind_of(AltStruct, @example)
  end

  def test_that_example_has_table_imethod
    assert_respond_to(@example, :table)
  end

  def test_that_empty_example_has_empty_table
    assert_equal({}, @empty_example.table)
  end

  def test_that_example_has_name_method
    assert_respond_to(@example, :name)
  end

  def test_that_example_has_given_name
    assert_equal("Kurtis", @example.name)
  end

  def test_that_example_takes_name
    assert_send([@example, :name=, "Dave"])
  end

  def test_that_example_has_taken_name
    @example.name = "Dave"
    assert_equal("Dave", @example.name)
  end

  def test_that_example_has_load_imethod
    assert_respond_to(@example, :load)
  end

  def test_that_load_takes_a_hash
    assert_send([@example, :load, { nickname: "Kurt" }])
  end

  def test_that_load_sets_imethods
    @example.load nickname: "Kurt"
    assert_respond_to(@example, :nickname)
  end

  def test_that_load_sets_correct_value
    @example.load nickname: "Kurt"
    assert_equal("Kurt", @example.nickname)
  end

  def test_that_example_has_dump_imethod
    assert_respond_to(@example, :dump)
  end

  def test_that_dump_contains_values
    assert_equal({ name: "Kurtis", age: 24 }, @example.dump)
  end

  def test_that_selective_dump_contains_selective_values
    assert_equal({ age: 24 }, @example.dump(:age))
  end

  def test_inspect_has_values
    assert_match(/name="Kurtis" age=24/, @example.inspect)
  end

  def test_that_other_class_isnt_affected
    refute_respond_to(Profile.new, :name)
  end
end
