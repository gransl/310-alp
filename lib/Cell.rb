class Cell 
  # Setters & Getters
  attr_accessor :oem, :model, :launch_announced, :launch_status,  :body_dimensions, :body_weight, :body_sim, :display_type, :display_size, :display_resolution, :feature_sensors, :platform_os

  def initialize(oem, model, launch_ann, launch_status, body_dim, body_weight, body_sim, display_type, display_size, display_res, feat_sense, plat_os)
    @oem = oem
    @model = model
    @launch_announced = launch_ann
    @launch_status = launch_status
    @body_dimensions = body_dim
    @body_weight = body_weight
    @body_sim = body_sim
    @display_type = display_type
    @display_size = display_size
    @display_resolution = display_res
    @features_sensors = feat_sense
    @platform_os = plat_os
  end
end