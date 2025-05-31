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

  def to_s
    string = []
    string << "OEM: #{@oem}"
    string << "Model: #{@model}"
    string << "Launch Announced: #{@launch_ann}"
    string << "Launch Status: #{@launch_status}"
    string << "Body Dimensions: #{@body_dimensions}"
    string << "Body Weight (g): #{@body_weight}"
    string << "Body Sim: #{@body_sim}"
    string << "Display Type: #{@display_type}"
    string << "Display Size (in): #{@display_size}"
    string << "Display Resolution: #{@display_res}"
    string << "Features Sensors: #{@features_sensors}"
    string << "Platform OS: #{@platform_os}"

    string.join("\n")
  end
end