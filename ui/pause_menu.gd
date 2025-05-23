extends Node3D

@onready var original_position: Vector3 = position

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var buttons: Node3D = %Buttons

@onready var selector: Selector = %Selector
@onready var resume_button: Area3D = %ResumeButton

@onready var is_paused: bool = false:
	set(value):
		selector.is_paused = value
		is_paused = value


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	hide_buttons()


func hide_buttons() -> void:
	for child in buttons.get_children() as Array[Node3D]:
		child.hide()


func show_buttons() -> void:
	for child in buttons.get_children() as Array[Node3D]:
		child.show()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if not is_paused:
			pause_game()
			print("PAUSE")
		else:
			unpause_game()
			print("UNPAUSE")


func pause_game() -> void:
	animation_player.speed_scale = 1.5
	animation_player.play("Unroll")
	selector.current_button = resume_button
	is_paused = true


func unpause_game() -> void:
	animation_player.speed_scale = 1.5

	if animation_player.current_animation == "Unroll":
		animation_player.play_backwards("Unroll")
	else:
		animation_player.play("Dismiss")

	is_paused = false


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
	print("OPTIONS MENU")


func _on_exit_button_button_clicked(_button: Area3D) -> void:
	get_tree().quit()
