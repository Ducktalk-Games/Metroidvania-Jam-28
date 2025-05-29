extends Sprite3D
@onready var key_animation_player: AnimationPlayer = %KeyAnimationPlayer

var char_in_area: bool = false
var key_tween: Tween

var is_joy: bool = false:
	set(value):
		if value != is_joy:
			frame = int(not value)

		is_joy = value


func pop_in_key() -> void:
	key_animation_player.play("pop_in")


func pop_out_key() -> void:
	key_animation_player.play("pop_in", -1, -1.5, true)


func _input(event: InputEvent) -> void:
	is_joy = event is InputEventJoypadButton or event is InputEventJoypadMotion


func _on_item_pickup_body_entered(body: Node3D) -> void:
	if body is Character:
		char_in_area = true
		pop_in_key()


func _on_item_pickup_body_exited(body: Node3D) -> void:
	if body is Character:
		char_in_area = false
		pop_out_key()
