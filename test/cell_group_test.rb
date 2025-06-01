# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/cell_group'
require_relative '../lib/ingestor'

class CellGroupTest < Minitest::Test
  def setup
    file_path = File.expand_path('test.csv', __dir__)
    test_ingestor = Ingestor.new(file_path)
    test_ingestor.ingest
    @test_cg = test_ingestor.create_cell_group
  end

  def test_avg_body_weight
    actual = @test_cg.avg_body_weight
    assert_in_delta(179.5, actual, 0.01)
  end

  def test_avg_body_weight_by_company
    actual = @test_cg.avg_body_weight_by_company('NimbusTech')
    assert_in_delta(185.0, actual, 0.001)
  end

  def test_max_avg_body_weight_by_company
    actual = @test_cg.max_avg_body_weight_by_company
    assert_equal('Vertex', actual[0])
    assert_in_delta(190.0, actual[1], 0.001)
  end

  def test_sd_body_weight
    actual = @test_cg.sd_body_weight
    assert_in_delta(9.88, actual, 0.01)
  end

  def test_avg_display_size
    actual = @test_cg.avg_display_size
    assert_in_delta(6.43, actual, 0.01)
  end

  def test_sd_display_size
    actual = @test_cg.sd_display_size
    assert_in_delta(0.25, actual, 0.01)
  end

  def test_phones_announced_in_year
    actual = @test_cg.phones_announced_in_year(2024)
    expected = ['NimbusTech Nimbus X1', 'Vertex Alpha Z']
    assert_equal(expected, actual)
  end

  def test_announce_yr_different_than_release_yr
    actual = @test_cg.announce_yr_different_than_release_yr
    expected = ['NimbusTech Nimbus X1', 'Vertex Alpha Z']
    assert_equal(expected, actual)
  end

  def test_phone_count_per_year
    actual = @test_cg.phone_count_per_year
    expected = { '2020': 2 }
    assert_equal(expected, actual)
  end

  def test_brand_list
    actual = %w[NimbusTech SkyWave Vertex Zentauri]
    assert_equal(@test_cg.brand_list, actual)
  end

  def test_brand_count
    expected = <<~TEXT.chomp
      NimbusTech: 2
      SkyWave: 1
      Vertex: 1
      Zentauri: 1
    TEXT
    actual = @test_cg.brand_count
    assert_equal(expected, actual)
  end

  # TODO: change if "V1" isn't a feature
  def test_one_feature_phone_count
    actual = @test_cg.one_feature_phone_count
    assert_equal(2, actual)
  end
end
