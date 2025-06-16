class_name AmpSlider
extends Node3D

var options_amp: OptionsAmp

#region Sound Variables

@export_enum("Master", "MUSIC", "SFX") var bus_id: int = 0
@export var initial_volume: float = 0.5

var volume: float:
	set(value):
		if start_point and end_point:
			var clamped_val: float = clampf(value, 0.0, 1.0)
			var lerped_postion: Vector3 = lerp(start_point_marker.global_position, end_point_marker.global_position, clamped_val)
			slider_area.global_position.x = lerped_postion.x
			slider_area.global_position.z = lerped_postion.z
			AudioServer.set_bus_volume_linear(bus_id, clamped_val)
			volume = clamped_val

#endregion

#region Slider Variables

@export var energy_max: float = 0.5
@export var slider_area: Area3D
@export var slider_mesh: MeshInstance3D
@export var slider_step := 0.1

@onready var slider_mesh_mat: StandardMaterial3D = slider_mesh.material_override.duplicate()
var grabbed: bool = false
var hovered: bool = false:
	set(value):
		if options_amp:
			options_amp.current_slider_index = options_amp.sliders.find(self)

		focused = value
		hovered = value

var focused: bool = false:
	set(value):
		if slider_mesh_mat:
			slider_mesh_mat.emission_energy_multiplier = float(value) * energy_max

		focused = value

#endregion

#region Point Variables

@export var start_point_marker: Marker3D
@export var end_point_marker: Marker3D


class Point:
	var marker: Marker3D
	var screen_space_loc: Vector2

@onready var start_point: Point = Point.new()
@onready var end_point: Point = Point.new()

#endregion


func _ready() -> void:

	slider_mesh.material_override = slider_mesh_mat

	# Initialise Points
	start_point.marker = start_point_marker
	end_point.marker = end_point_marker

	volume = initial_volume


func _input(event: InputEvent) -> void:
	if not options_amp.has_input_enabled: return

	if Input.is_action_just_pressed("button_select") and hovered:
		grabbed = true

	if Input.is_action_just_released("button_select") and grabbed:
		grabbed = false

	if grabbed:
		volume = remap(options_amp.mouse_x_location, start_point.screen_space_loc.x, end_point.screen_space_loc.x, 0.0, 1.0)

	if focused:
		var left_right_input: float = Input.get_axis("ui_left", "ui_right")
		var target_volume: float = volume + left_right_input * slider_step

		if left_right_input and (0.0 <= target_volume and target_volume <= 1.0):
			get_tree().create_tween().tween_property(self, "volume", target_volume, 0.1)


func _on_mouse_entered() -> void:
	hovered = true


func _on_mouse_exited() -> void:
	hovered = false
