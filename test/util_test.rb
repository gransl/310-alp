# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/util'

class TestUtil < Minitest::Test
  def test_float?
    is_float = 3.2
    is_float2 = 4
    is_not_float = 'oh hello!'

    assert Util.float?(is_float)
    assert Util.float?(is_float2)
    refute Util.float?(is_not_float)
    refute Util.float?(nil)
  end

  def test_mean
    vals = [4, 8, 15, 16, 23, 42]
    assert_in_delta 18.0, Util.mean(vals), 0.01
  end

  def test_standard_deviation
    vals = [4, 8, 15, 16, 23, 42]
    assert_in_delta 13.49, Util.standard_deviation(vals), 0.01
  end
end
