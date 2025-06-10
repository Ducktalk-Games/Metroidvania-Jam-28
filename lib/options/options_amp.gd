class_name OptionsAmp
extends Node3D

@export
var has_mouse_input_enabled: bool = false

@export
var has_input_enabled: bool = false

@export
var debug_music_label: Label3D

@export
var debug_sfx_label: Label3D

@export
var debug_master_label: Label3D

@onready
var point_a: Marker3D = $PointA

@onready 
var point_b: Marker3D = $PointB

@onready
var point_c: Marker3D = $PointC

@onready 
var point_d: Marker3D = $PointD

@onready
var point_e: Marker3D = $PointE

@onready 
var point_f: Marker3D = $PointF

@onready
var music_slider: Area3D = %MusicSlider

@onready
var sfx_slider: Area3D = %SfxSlider

@onready
var master_slider: Area3D = %MasterSlider

@onready
var focused_slider: Area3D = %MasterSlider

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

@onready
var master_slider_mat: StandardMaterial3D = $MasterSlider/SliderCollision/SliderMesh.get_active_material(0)

var master_volume: float:
	set(value):
		var clamped_val: float = clampf(value, 0.0, 1.0)
		master_slider.position = lerp(point_a.position, point_b.position, clamped_val)

		if debug_master_label:
			debug_master_label.text = str(int(snapped(clamped_val, 0.01) * 100), "%")

		master_volume = clamped_val

var music_volume: float:
	set(value):
		var clamped_val: float = clampf(value, 0.0, 1.0)
		music_slider.position = lerp(point_c.position, point_d.position, clamped_val)

		if debug_music_label:
			debug_music_label.text = str(int(snapped(clamped_val, 0.01) * 100), "%")

		music_volume = clamped_val

var sfx_volume: float:
	set(value):
		var clamped_val: float = clampf(value, 0.0, 1.0)
		sfx_slider.position = lerp(point_e.position, point_f.position, clamped_val)

		if debug_sfx_label:
			debug_sfx_label.text = str(int(snapped(clamped_val, 0.01) * 100), "%")

		sfx_volume = clamped_val

var point_a_ss_loc: Vector2
var point_b_ss_loc: Vector2
var slider_hovered: bool = false
var slider_grabbed: bool = false


func _ready() -> void:
	master_slider_mat.emission_energy_multiplier = 2.0
	music_slider_mat.emission_energy_multiplier = 0.0
	sfx_slider_mat.emission_energy_multiplier = 0.0
	master_volume = 1.0
	music_volume = 1.0
	sfx_volume = 1.0


func _process(delta: float) -> void:
	if !has_input_enabled: return

	AudioServer.set_bus_volume_linear(music_bus_i, music_volume)
	AudioServer.set_bus_volume_linear(sfx_bus_i, sfx_volume)
	AudioServer.set_bus_volume_linear(master_bus_i, master_volume)

	if slider_grabbed and has_mouse_input_enabled:
		var current_mouse_y_position: float = get_viewport().get_mouse_position().x
		music_volume = remap(current_mouse_y_position, point_a_ss_loc.x, point_b_ss_loc.x, 0.0, 1.0)


func _input(event: InputEvent) -> void:
	if !has_input_enabled: return
	var is_locked_ui: bool = false

	var direction_input: float = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

	if focused_slider == %MasterSlider:
		master_slider_mat.emission_energy_multiplier = 2.0
		music_slider_mat.emission_energy_multiplier = 0.0
		sfx_slider_mat.emission_energy_multiplier = 0.0
		master_volume+=direction_input * 0.01

		if Input.is_action_just_pressed("ui_down") and !is_locked_ui:
			call_deferred("set_focused_slider", %MusicSlider)

	if focused_slider == %MusicSlider:
		master_slider_mat.emission_energy_multiplier = 0.0
		music_slider_mat.emission_energy_multiplier = 2.0
		sfx_slider_mat.emission_energy_multiplier = 0.0
		music_volume+=direction_input * 0.01

		if Input.is_action_just_pressed("ui_up") and !is_locked_ui:
			call_deferred("set_focused_slider", %MasterSlider)

		if Input.is_action_just_pressed("ui_down") and !is_locked_ui:
			call_deferred("set_focused_slider", %SfxSlider)

	if focused_slider == %SfxSlider:
		master_slider_mat.emission_energy_multiplier = 0.0
		music_slider_mat.emission_energy_multiplier = 0.0
		sfx_slider_mat.emission_energy_multiplier = 2.0
		sfx_volume+=direction_input * 0.01

		if Input.is_action_just_pressed("ui_up") and !is_locked_ui:
			call_deferred("set_focused_slider", %MusicSlider)

	if Input.is_action_just_pressed("button_select") and slider_hovered and has_mouse_input_enabled:
		point_a_ss_loc = get_viewport().get_camera_3d().unproject_position(point_a.global_position)
		point_b_ss_loc = get_viewport().get_camera_3d().unproject_position(point_b.global_position)
		slider_grabbed = true

	if Input.is_action_just_released("button_select") and has_mouse_input_enabled:
		slider_grabbed = false


func _on_slider_mouse_entered() -> void:
	if has_mouse_input_enabled:
		slider_hovered = true


func _on_slider_mouse_exited() -> void:
	if has_mouse_input_enabled:
		slider_hovered = false


func set_focused_slider(slider: Area3D) -> void:
	focused_slider = slider
