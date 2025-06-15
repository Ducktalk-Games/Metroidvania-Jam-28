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

@export var pause_menu_stream_player: AudioStreamPlayer

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
		pause_menu_stream_player.play()

		Global.current_menu_state = Global.MenuState.PAUSE
		Global.current_parent_menu_state = Global.MenuState.PAUSE
		Global.disable_player_input()
		Global.lock_dialogue_input = true

		if Global.are_lights_dimmed:
			Global.dim_lights_and_spotlight(Global.who_is_dimmed, false)
			Global.last_dimmed = Global.who_is_dimmed
			Global.is_paused_whilst_lights_dimmed = true

			#Wait for the lights to dim before pausing
			await get_tree().create_timer(0.25).timeout

		animation_player.speed_scale = 1.5
		animation_player.play("Unroll")
		selector.current_button = resume_button
		is_paused = true
		Global.dim_lights_and_spotlight(Global.stage.patron)
		original_node = Global.patron_animation_tree.state_machine.get_current_node()
		Global.patron_animation_tree.state_machine.travel("PlayingPianoPause")
		await get_tree().create_timer(0.5).timeout
		#get_tree().create_tween().tween_property(music, "volume_db", -10.0, 0.3)
		original_song = Global.stage.patron.music["parameters/switch_to_clip"]
		Global.stage.patron.music.play()
		Global.stage.patron.set_music_to("pause_theme")


func unpause_game() -> void:
	if Global.current_menu_state == Global.MenuState.PAUSE:
		Global.current_menu_state = Global.MenuState.GAME
		animation_player.speed_scale = 1.5

		if animation_player.current_animation == "Unroll":
			animation_player.play_backwards("Unroll")
		else:
			animation_player.play("Dismiss")

		Global.stage.patron.set_music_to(original_song)

		Global.patron_animation_tree.state_machine.travel(original_node)
		Global.dim_lights_and_spotlight(Global.stage.patron, false)
		if Global.is_paused_whilst_lights_dimmed:
			Global.dim_lights_and_spotlight(Global.last_dimmed, true)
			Global.is_paused_whilst_lights_dimmed = false
			await get_tree().create_timer(0.25).timeout

		if !Global.was_input_disabled_before_pause:
			Global.enable_player_input()

		Global.was_input_disabled_before_pause = false
		await call_deferred("enable_dialogue_input")
		is_paused = false


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
	Global.reset_to_title()
