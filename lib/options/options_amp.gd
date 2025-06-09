class_name OptionsAmp
extends Node3D

@export
var has_mouse_input_enabled: bool = false

@export
var debug_label: Label3D

@onready
var point_a: Marker3D = $PointA

@onready 
var point_b: Marker3D = $PointB

@onready
var music_slider: Area3D = %MusicSlider

@onready
var sfx_slider: Area3D = %SfxSlider

@onready
var focused_slider: Area3D = %MusicSlider

@onready
var music_bus_i: int = AudioServer.get_bus_index("Music")

@onready
var sfx_bus_i: int = AudioServer.get_bus_index("SFX")

@onready
var master_bus_i: int = AudioServer.get_bus_index("Master")

@onready
var music_slider_mat: StandardMaterial3D = $MusicSlider/SliderCollision/SliderMesh.get_active_material(0)

@onready
var sfx_slider_mat: StandardMaterial3D = $SfxSlider/SliderCollision/SliderMesh.get_active_material(0)

var music_volume: float:
	set(value):
		var clamped_val: float = clampf(value, 0.0, 1.0)
		music_slider.position = lerp(point_a.position, point_b.position, clamped_val)

		if debug_label:
			debug_label.text = str(int(snapped(clamped_val, 0.01) * 100), "%")

		music_volume = clamped_val

var sfx_volume: float:
	set(value):
		var clamped_val: float = clampf(value, 0.0, 1.0)
		music_slider.position = lerp(point_a.position, point_b.position, clamped_val)

		if debug_label:
			debug_label.text = str(int(snapped(clamped_val, 0.01) * 100), "%")

		sfx_volume = clamped_val

var master_volume: float:
	set(value):
		var clamped_val: float = clampf(value, 0.0, 1.0)
		music_slider.position = lerp(point_a.position, point_b.position, clamped_val)

		if debug_label:
			debug_label.text = str(int(snapped(clamped_val, 0.01) * 100), "%")

		master_volume = clamped_val

var point_a_ss_loc: Vector2
var point_b_ss_loc: Vector2
var slider_hovered: bool = false
var slider_grabbed: bool = false


func _ready() -> void:
	master_volume = 1.0
	music_volume = 1.0
	sfx_volume = 1.0
	#var music_slider_mat: StandardMaterial3D = music_slider_mesh.
	var slider_tween := create_tween()
	## TODO: TOM
	#slider_tween.tween_property(music_slider_mat, "emission_energy_multiplier", 4.0, .2).as_relative()
	#slider_tween.tween_property(music_slider_mat, "emission_energy_multiplier", -4.0, .2).set_delay(0.1).as_relative()


func _process(delta: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus_i, music_volume)
	AudioServer.set_bus_volume_linear(sfx_bus_i, sfx_volume)
	AudioServer.set_bus_volume_linear(master_bus_i, master_volume)

	#if (focused_slider == %MusicSlider):
		#slider_tween.tween_property(music_slider_mat, "emission_energy_multiplier", 2.0, 0.1).as_relative()

	if slider_grabbed:
		var current_mouse_y_position: float = get_viewport().get_mouse_position().x
		music_volume = remap(current_mouse_y_position, point_a_ss_loc.x, point_b_ss_loc.x, 0.0, 1.0)


func _input(event: InputEvent) -> void:
	var direction_input: float = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

	if (focused_slider == %MusicSlider):
		#var tween := create_tween()
		##music_slider_mat.emission_energy = 1.0
		#tween.tween_property(music_slider_mat, "emission_energy_multiplier", 2.0, 0.1).as_relative()
		#tween.tween_property(music_slider_mat, "emission_energy_multiplier", 0.0, 2.0).as_relative().set_delay(0.2)
		pass

	if Input.is_action_just_pressed("button_select") and slider_hovered and has_mouse_input_enabled:
		point_a_ss_loc = get_viewport().get_camera_3d().unproject_position(point_a.global_position)
		point_b_ss_loc = get_viewport().get_camera_3d().unproject_position(point_b.global_position)
		slider_grabbed = true

	if Input.is_action_just_released("button_select") and has_mouse_input_enabled:
		slider_grabbed = false


func _on_slider_mouse_entered() -> void:
	if (has_mouse_input_enabled):
		slider_hovered = true


func _on_slider_mouse_exited() -> void:
	if (has_mouse_input_enabled):
		slider_hovered = false
