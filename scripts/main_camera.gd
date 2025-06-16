class_name MainCamera

extends Camera3D

@onready var main_menu: MainMenu = %MainMenu

@export var camera_audio: AudioStreamPlayer

@export var options_menu: OptionsAmp

@export var options_cam: Camera3D
@export var credits_cam: Camera3D

@onready var main_cam_transform: Transform3D = global_transform
@onready var main_cam_fov: float = fov

signal pivoted_to_parent_menu


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		camera_audio.play()
		match Global.current_menu_state:
			Global.MenuState.CREDITS:
				pivot_from_credits()

			Global.MenuState.OPTIONS:
				pivot_from_options(false)

			Global.MenuState.OPTIONS_INGAME:
				pivot_from_options(true)


func pivot_to_options(ingame: bool = false) -> void:

	if ingame:
		Global.current_menu_state = Global.MenuState.OPTIONS_INGAME

	if !ingame:
		Global.current_menu_state = Global.MenuState.OPTIONS

	main_cam_transform = global_transform
	main_cam_fov = fov

	var tween: Tween = get_tree().create_tween().set_parallel()
	tween.tween_property(self, "global_transform", options_cam.global_transform, 0.8)
	tween.tween_property(self, "fov", options_cam.fov, 0.8)
	await tween.finished
	tween.kill()

	Global.enable_options_menu()

	get_tree().create_tween().tween_property(options_menu.options_audio_stream, "volume_db", 0.0, 0.5)


func pivot_from_options(ingame: bool = false) -> void:

	if ingame:
		Global.current_menu_state = Global.MenuState.PAUSE
	else:
		Global.current_menu_state = Global.current_parent_menu_state

	Global.disable_options_menu()
	var tween: Tween = get_tree().create_tween().set_parallel()
	tween.tween_property(self, "global_transform", main_cam_transform, 0.8)
	tween.tween_property(self, "fov", main_cam_fov, 0.8)
	tween.tween_property(options_menu.options_audio_stream, "volume_db", -20.0, 0.5)
	await tween.finished
	tween.kill()

	emit_pivoted_and_grab_play_focus()


func pivot_to_credits() -> void:
	Global.current_menu_state = Global.MenuState.CREDITS
	main_cam_transform = global_transform
	main_cam_fov = fov

	var tween: Tween = get_tree().create_tween().set_parallel()
	tween.tween_property(self, "global_transform", credits_cam.global_transform, 0.8)
	tween.tween_property(self, "fov", credits_cam.fov, 0.8)
	await tween.finished
	tween.kill()


func pivot_from_credits() -> void:
	Global.current_menu_state = Global.current_parent_menu_state

	var tween: Tween = get_tree().create_tween().set_parallel()
	tween.tween_property(self, "global_transform", main_cam_transform, 0.8)
	tween.tween_property(self, "fov", main_cam_fov, 0.8)
	await tween.finished
	tween.kill()

	emit_pivoted_and_grab_play_focus()


func emit_pivoted_and_grab_play_focus() -> void:
	pivoted_to_parent_menu.emit()
	main_menu.play_button.call_deferred("grab_focus")
