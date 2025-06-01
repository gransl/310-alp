# frozen_string_literal: true

# Loads attributes about each row of a CSV into an object
#
# Cell objects can be grouped together for aggregate data using CellGroup class.
# @see CellGroup
class Cell
  # Getters (no Setters, shouldn't be possible to change these values)
  attr_reader :oem, :model, :launch_announced, :launch_status,  :body_dimensions, :body_weight,
         :body_sim, :display_type, :display_size, :display_resolution, :features_sensors,
              :platform_os

  # @param [Object] oem Original Manufacturer
  # @param [Object] model Phone Model Name
  # @param [Object] launch_ann Year phone was announced
  # @param [Object] launch_status status of launch: Cancelled, Discontinued, or Available with year
  # @param [Object] body_dim Body dimensions of the phone
  # @param [Object] body_weight Weight of the phone
  # @param [Object] body_sim Sim Card type of the phone
  # @param [Object] display_type Kind of display on the phone
  # @param [Object] display_size Size of the display
  # @param [Object] display_res Resolution fo the display
  # @param [Object] feat_sense List of phone features
  # @param [Object] plat_os OS the phone runs
  def initialize(oem, model, launch_ann, launch_status, body_dim, body_weight, body_sim, display_type, display_size,
                 display_res, feat_sense, plat_os)
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
    [
      "OEM: #{@oem}",
      "Model: #{@model}",
      "Launch Announced: #{@launch_announced}",
      "Launch Status: #{@launch_status}",
      "Body Dimensions: #{@body_dimensions}",
      "Body Weight (g): #{@body_weight}",
      "Body Sim: #{@body_sim}",
      "Display Type: #{@display_type}",
      "Display Size (in): #{@display_size}",
      "Display Resolution: #{@display_resolution}",
      "Features Sensors: #{@features_sensors}",
      "Platform OS: #{@platform_os}"
    ].join("\n")
  end

end
