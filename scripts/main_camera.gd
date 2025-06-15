class_name MainCamera

extends Camera3D

@onready var camera_animation_player: AnimationPlayer = %CameraAnimationPlayer
@onready var main_menu: MainMenu = %MainMenu

@export var camera_audio: AudioStreamPlayer

@export var options_menu: OptionsAmp

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

	camera_animation_player.play("pivot_to_options")
	get_tree().create_tween().tween_property(options_menu.options_audio_stream, "volume_db", 0.0, 0.5)


func pivot_from_options(ingame: bool = false) -> void:

	if ingame:
		Global.current_menu_state = Global.MenuState.PAUSE
	else:
		Global.current_menu_state = Global.current_parent_menu_state

	Global.disable_options_menu()
	camera_animation_player.play("pivot_to_options", -1, -1, true)
	wait_for_from_anim_to_finish()

	get_tree().create_tween().tween_property(options_menu.options_audio_stream, "volume_db", -20.0, 0.5).finished


func pivot_to_credits() -> void:
	Global.current_menu_state = Global.MenuState.CREDITS
	camera_animation_player.play("pivot_to_credits")


func pivot_from_credits() -> void:
	Global.current_menu_state = Global.current_parent_menu_state
	camera_animation_player.play("pivot_to_credits", -1, -1, true)
	wait_for_from_anim_to_finish()


func wait_for_from_anim_to_finish() -> void:
	await camera_animation_player.animation_finished
	pivoted_to_parent_menu.emit()
	main_menu.play_button.call_deferred("grab_focus")
