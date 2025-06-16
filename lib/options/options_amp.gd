class_name OptionsAmp
extends Node3D

var settled: bool = false
var has_input_enabled: bool = false
var mouse_x_location: float = 0.0

@onready var sliders: Array[AmpSlider]

var current_slider_index: int = 0:
	set(value):
		if 0 <= value and value < sliders.size():
			sliders[current_slider_index].focused = false
			sliders[value].focused = true
			current_slider_index = value

@export var options_audio_stream: AudioStreamPlayer


func options_screen_settled() -> void:
	for slider in sliders:
		if (slider.start_point and slider.end_point) and not (slider.start_point.screen_space_loc or slider.end_point.screen_space_loc):
			slider.start_point.screen_space_loc = get_viewport().get_camera_3d().unproject_position(slider.start_point_marker.global_position)
			slider.end_point.screen_space_loc = get_viewport().get_camera_3d().unproject_position(slider.end_point_marker.global_position)

	settled = true


func _ready() -> void:
	Global.options_amp = self

	for child in get_children():
		if child is AmpSlider:
			child.options_amp = self
			sliders.append(child)

	if sliders:
		sliders[0].focused = true


func _input(event: InputEvent) -> void:
	if !has_input_enabled: return

	if event is InputEventMouseMotion:
		mouse_x_location = event.position.x

	var up_down_input: int = Input.get_axis("ui_up", "ui_down")

	if up_down_input != 0:
		var incremented_clamped_index: int = clampi(current_slider_index + up_down_input, 0, sliders.size()-1)

		if current_slider_index != incremented_clamped_index:
			sliders[current_slider_index].focused = false
			current_slider_index = incremented_clamped_index
			sliders[current_slider_index].focused = true
