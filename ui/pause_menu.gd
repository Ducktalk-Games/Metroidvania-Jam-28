extends Node3D

@onready
var original_position: Vector3 = position

@onready
var animation_player: AnimationPlayer = %AnimationPlayer

@onready
var buttons: Node3D = %Buttons

@onready
var selector: Selector = %Selector

@onready
var resume_button: Area3D = %ResumeButton

@export
var stage_camera: MainCamera

var original_node: String
var original_song: StringName

@onready var is_paused: bool = false:
	set(value):
		selector.is_paused = value
		is_paused = value


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	hide_buttons()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") && Global.can_pause_game:
		if !is_paused:
			pause_game()
		else:
			unpause_game()


func hide_buttons() -> void:
	for child in buttons.get_children() as Array[Node3D]:
		child.hide()


func show_buttons() -> void:
	for child in buttons.get_children() as Array[Node3D]:
		child.show()


func pause_game() -> void:
	if Global.is_input_disabled: Global.was_input_disabled_before_pause = true
	#print(str(Global.MenuState.keys()[Global.current_menu_state]))
	if Global.current_menu_state == Global.MenuState.GAME:
		Global.current_menu_state = Global.MenuState.PAUSE
		Global.current_parent_menu_state = Global.MenuState.PAUSE
		Global.disable_player_input()
		Global.lock_dialogue_input = true

		if Global.are_lights_dimmed:
			Global.last_person_on_spotlight = Global.who_is_on_spotlight
			Global.is_paused_whilst_lights_dimmed = true
		else:
			Global.dim_lights(true)

		unroll_menu()
		Global.control_spotlight(Global.stage.patron, true, 0.6)

		is_paused = true
		#get_tree().create_tween().tween_property(music, "volume_db", -10.0, 0.3)


func unroll_menu() -> void:
	original_node = Global.patron_animation_tree.state_machine.get_current_node()
	animation_player.speed_scale = 1.5
	animation_player.play("Unroll")
	selector.current_button = resume_button
	Global.patron_animation_tree.state_machine.travel("PlayingPianoPause")
	await get_tree().create_timer(0.5).timeout
	original_song = Global.stage.patron.music["parameters/switch_to_clip"]
	Global.stage.patron.music.play()
	Global.stage.patron.set_music_to("pause_theme")


func unpause_game() -> void:
	if Global.current_menu_state == Global.MenuState.PAUSE:
		Global.current_menu_state = Global.MenuState.GAME
		animation_player.speed_scale = 1.5

		if Global.is_paused_whilst_lights_dimmed:
			roll_menu()
			await Global.control_spotlight(Global.stage.patron, false, 0.5)
			await Global.control_spotlight(Global.last_person_on_spotlight, true, 0.2)
			Global.is_paused_whilst_lights_dimmed = false
		else:
			Global.control_spotlight(Global.stage.patron, false)
			Global.dim_lights(false)
			roll_menu()

		Global.stage.patron.set_music_to(original_song)
		Global.patron_animation_tree.state_machine.travel(original_node)
		if !Global.was_input_disabled_before_pause:
			Global.enable_player_input()

		Global.was_input_disabled_before_pause = false
		await call_deferred("enable_dialogue_input")
		is_paused = false


func roll_menu() -> void:
	if animation_player.current_animation == "Unroll":
		animation_player.play_backwards("Unroll")
	else:
		animation_player.play("Dismiss")


func enable_dialogue_input() -> void:
		Global.lock_dialogue_input = false


func _on_dismiss_finished() -> void:
	animation_player.stop()
	position = original_position


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Unroll" and is_paused:
		animation_player.speed_scale = 0.2
		animation_player.play("Idle")


func _on_resume_button_button_clicked(_button: Area3D) -> void:
	unpause_game()


func _on_options_button_button_clicked(_button: Area3D) -> void:
	stage_camera.pivot_to_options(true)
	Global.enable_options_menu()


func _on_exit_button_button_clicked(_button: Area3D) -> void:
	Global.current_menu_state = Global.MenuState.MAIN
	Global.current_parent_menu_state = Global.MenuState.MAIN
	is_paused = false
	#Reset Global State
	Global.are_lights_dimmed = false
	Global.is_paused_whilst_lights_dimmed = false
	Global.was_input_disabled_before_pause = false
	Global.was_input_disabled_before_pause = false
	Global.last_dimmed = null
	Global.who_is_dimmed = null
	Global.lock_dialogue_input = false
	#target_platform_level
	#current_platform_level
	get_tree().reload_current_scene()
