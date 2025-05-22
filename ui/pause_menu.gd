extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var original_position: Vector3 = position

var is_paused: bool


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		animation_player.speed_scale = 1.5

		if not is_paused:
			animation_player.play("Unroll")
			is_paused = true
		else:
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
