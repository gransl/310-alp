# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/cell'

class TestCell < Minitest::Test
  def setup
    @cell = Cell.new('NimbusTech', 'Nimbus X1', 'Cancelled', nil,
                     '160 x 75 x 8 mm', 180, 'Dual SIM (Nano-SIM)',
                     'AMOLED', 6.5, '2400 x 1080 pixels',
                     ['Fingerprint (under display)', 'Accelerometer', 'Gyroscope', 'Proximity'],
                     'NimbusOS 3.0')
  end

  def test_get_values
    assert_equal 'NimbusTech', @cell.oem
    assert_equal 'Nimbus X1', @cell.model
    assert_equal 'Cancelled', @cell.launch_announced
    assert_nil @cell.launch_status
    assert_equal '160 x 75 x 8 mm', @cell.body_dimensions
    assert_equal 180, @cell.body_weight
    assert_equal 'Dual SIM (Nano-SIM)', @cell.body_sim
    assert_equal 'AMOLED', @cell.display_type
    assert_equal 6.5, @cell.display_size
    assert_equal '2400 x 1080 pixels', @cell.display_resolution
    assert_equal ['Fingerprint (under display)', 'Accelerometer', 'Gyroscope', 'Proximity'],
                 @cell.features_sensors
    assert_equal 'NimbusOS 3.0', @cell.platform_os
  end

  def test_to_s
    expected = [
      'OEM: NimbusTech',
      'Model: Nimbus X1',
      'Launch Announced: Cancelled',
      'Launch Status: ',
      'Body Dimensions: 160 x 75 x 8 mm',
      'Body Weight (g): 180',
      'Body Sim: Dual SIM (Nano-SIM)',
      'Display Type: AMOLED',
      'Display Size (in): 6.5',
      'Display Resolution: 2400 x 1080 pixels',
      'Features Sensors: Fingerprint (under display), Accelerometer, Gyroscope, Proximity',
      'Platform OS: NimbusOS 3.0'
    ].join("\n")

    assert_equal expected, @cell.to_s
  end
end
