class Cell 
  # Setters & Getters
  attr_accessor :oem, :model, :launch_announced, :launch_status,  :body_dimensions, :body_weight, :body_sim, :display_type, :display_size, :display_resolution, :feature_sensors, :platform_os

  def initialize()
    @oem
    @model
    @launch_announced
    @launch_status
    @body_dimensions
    @body_weight
    @body_sim
    @display_type
    @display_size
    @display_resolution
    @features_sensors
    @platform_os
  end
end