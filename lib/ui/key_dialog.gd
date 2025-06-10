@tool
class_name KeyDialog
extends Sprite3D

@onready var key_animation_player: AnimationPlayer = %KeyAnimationPlayer

enum KeyAction {
	INTERACT,
	SCISSORS,
	WATCH
}

@export var key_action: KeyAction:
	set(value):
		frame_coords.x = value
		key_action = value

var char_in_area: bool = false
var key_tween: Tween

var is_joy: bool = false


func _ready() -> void:
	hide()


func pop_in_key() -> void:
	key_animation_player.play("pop_in")


func pop_out_key() -> void:
	key_animation_player.play("pop_in", -1, -1.5, true)


func _input(event: InputEvent) -> void:
	is_joy = not (event is InputEventJoypadButton or event is InputEventJoypadMotion)
	frame_coords.y = int(is_joy)

	if key_action == KeyAction.SCISSORS:
		if Input.is_action_just_pressed("attack"):
			pop_out_key()
			key_action = KeyAction.INTERACT

	if key_action == KeyAction.WATCH:
		if Input.is_action_just_pressed("switch"):
			pop_out_key()
			key_action = KeyAction.INTERACT


func _on_item_pickup_body_entered(body: Node3D) -> void:
	if body is Character:
		char_in_area = true
		pop_in_key()


func _on_item_pickup_body_exited(body: Node3D) -> void:
	if body is Character:
		char_in_area = false
		pop_out_key()
