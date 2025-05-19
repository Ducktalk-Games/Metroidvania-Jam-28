class_name CanReceiveInput
extends Component

signal move_left_right_pressed(left_right: float)
signal jump_pressed(just_pressed: bool)


func _input(event: InputEvent) -> void:
	move_left_right_pressed.emit(Input.get_axis("move_left", "move_right"))
	jump_pressed.emit(Input.is_action_just_pressed("jump"))
