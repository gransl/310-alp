# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/cell_group'
require_relative '../lib/ingestor'

class IngestorTest < Minitest::Test
  def setup
    file_path = File.expand_path('test.csv', __dir__)
    test_ingestor = Ingestor.new(file_path)
    test_ingestor.ingest
    @test_cg = test_ingestor.create_cell_group
  end

  def test_ingest
    assert_raises(ArgumentError) do
      Ingestor.new('empty.csv')
    end

    assert_raises(ArgumentError) do
      Ingestor.new('bad.csv')
    end
  end

  def test_remove_duplicates
    print(@test_cg)
    assert_equal(5, @test_cg.size)
  end

  def test_clean_oem
    actual = @test_cg.return_cell(0).oem
    assert_equal('NimbusTech', actual)
  end

  def test_clean_model
    actual = @test_cg.return_cell(1).model
    assert_equal('Stratus 9', actual)
    assert_nil(@test_cg.return_cell(2).model)
  end

  def test_clean_launch_ann
    actual = @test_cg.return_cell(3).launch_announced
    assert_equal(2024, actual)
    assert_equal(Integer, actual.class)
    assert_nil(@test_cg.return_cell(2).launch_announced)
  end

  def test_clean_launch_status
    actual1 = @test_cg.return_cell(0).launch_status
    actual2 = @test_cg.return_cell(4).launch_status
    assert_equal('Available. Released 2020', actual1)
    assert_equal('Discontinued', actual2)
    assert_nil(@test_cg.return_cell(1).launch_status)
  end

  def test_clean_body_dim
    actual = @test_cg.return_cell(1).body_dimensions
    assert_equal('158 x 72 x 7.5 mm', actual)
  end

  def test_clean_body_wt
    actual1 = @test_cg.return_cell(2).body_weight
    actual2 = @test_cg.return_cell(4).body_weight
    assert_in_delta(185.0, actual1, 0.1)
    assert_in_delta(168.0, actual2, 0.1)
    assert_equal(Float, actual1.class)
    assert_equal(Float, actual2.class)
    assert_nil(@test_cg.return_cell(0).body_weight)
  end

  def test_clean_body_sim
    actual1 = @test_cg.return_cell(1).body_sim
    assert_equal('Single SIM (Nano-SIM)', actual1)
    assert_nil(@test_cg.return_cell(0).body_sim)
    assert_nil(@test_cg.return_cell(4).body_sim)
  end

  def test_clean_display_type
    actual1 = @test_cg.return_cell(3).display_type
    actual2 = @test_cg.return_cell(4).display_type
    assert_equal('AMOLED', actual1)
    assert_equal('OLED', actual2)
  end

  def test_clean_display_size
    actual1 = @test_cg.return_cell(0).display_size
    actual2 = @test_cg.return_cell(1).display_size
    assert_in_delta(6.5, actual1, 0.01)
    assert_in_delta(6.1, actual2, 0.01)
    assert_equal(Float, actual1.class)
    assert_equal(Float, actual2.class)
    assert_nil(@test_cg.return_cell(3).display_size)
  end

  def test_clean_display_resolution
    actual1 = @test_cg.return_cell(1).display_resolution
    actual2 = @test_cg.return_cell(3).display_resolution
    assert_equal('2280 x 1080 pixels', actual1)
    assert_equal('3200 x 1440 pixels', actual2)
    assert_nil(@test_cg.return_cell(2).display_resolution)
  end

  def test_clean_features_sensors
    actual1 = @test_cg.return_cell(1).features_sensors
    actual2 = @test_cg.return_cell(4).features_sensors
    assert_equal('Face recognition, Accelerometer, Proximity', actual1)
    assert_equal('V1', actual2)
    assert_nil(@test_cg.return_cell(2).features_sensors)
  end

  def test_clean_platform_os
    actual1 = @test_cg.return_cell(0).platform_os
    actual2 = @test_cg.return_cell(1).platform_os
    assert_equal('NimbusOS 3', actual1)
    assert_equal('SkyOS 2.5', actual2)
    assert_nil(@test_cg.return_cell(4).platform_os)
  end
end
