class_name OptionsAmp
extends Node3D

@export
var slider: Area3D

@export
var debug_label: Label3D

@export
var music_stream: AudioStreamPlayer

@export
var audio_stream: AudioStreamPlayer

@onready
var point_a: Marker3D = $PointA

@onready 
var point_b: Marker3D = $PointB

var master_volume: float:
	set(value):
		var clamped_val: float = clampf(value, 0.0, 1.0)
		slider.position = lerp(point_a.position, point_b.position, clamped_val)

		if debug_label:
			debug_label.text = str(int(snapped(clamped_val, 0.01) * 100), "%")

		master_volume = clamped_val

var point_a_ss_loc: Vector2
var point_b_ss_loc: Vector2
var slider_hovered: bool = false
var slider_grabbed: bool = false


func _ready() -> void:
	master_volume = 1.0


func _process(delta: float) -> void:
	music_stream.set_volume_linear(master_volume)

	if slider_grabbed:
		var current_mouse_y_position: float = get_viewport().get_mouse_position().x
		master_volume = remap(current_mouse_y_position, point_a_ss_loc.x, point_b_ss_loc.x, 0.0, 1.0)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("button_select") and slider_hovered:
		point_a_ss_loc = get_viewport().get_camera_3d().unproject_position(point_a.global_position)
		point_b_ss_loc = get_viewport().get_camera_3d().unproject_position(point_b.global_position)
		slider_grabbed = true

	if Input.is_action_just_released("button_select"):
		slider_grabbed = false


func _on_slider_mouse_entered() -> void:
	slider_hovered = true


func _on_slider_mouse_exited() -> void:
	slider_hovered = false
